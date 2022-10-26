#![allow(non_snake_case)]

use bulletproof::proofs::range_proof::RangeProof;
use curv::cryptographic_primitives::proofs::sigma_correct_homomorphic_elgamal_enc::HomoELGamalProof;
use curv::cryptographic_primitives::proofs::sigma_correct_homomorphic_elgamal_encryption_of_dlog::HomoELGamalDlogProof;
use juggling::proof_system::Helgamal;
use juggling::proof_system::Helgamalsegmented;
use juggling::proof_system::Proof;
use juggling::proof_system::Witness;
use juggling::segmentation::Msegmentation;
use sha2::Sha256;
use Errors;
use Errors::ErrorSegmentNum;

use curv::elliptic::curves::{secp256_k1::Secp256k1, Point, Scalar};

const SECRET_BIT_LENGTH: usize = 256;

#[derive(Serialize, Deserialize)]
pub struct VEShare {
    pub secret: Scalar<Secp256k1>,
    pub segments: Witness,
    pub encryptions: Helgamalsegmented,
    pub proof: Proof,
}

#[derive(Serialize, Deserialize)]
pub struct FirstMessage {
    pub segment_size: usize,
    pub D_vec: Vec<Point<Secp256k1>>,
    pub range_proof: RangeProof,
    pub Q: Point<Secp256k1>,
    pub E: Point<Secp256k1>,
    pub dlog_proof: HomoELGamalDlogProof<Secp256k1, Sha256>,
}

#[derive(Serialize, Deserialize)]
pub struct SegmentProof {
    pub k: usize,
    pub E_k: Point<Secp256k1>,
    pub correct_enc_proof: HomoELGamalProof<Secp256k1, Sha256>,
}

impl VEShare {
    pub fn create(
        secret: &Scalar<Secp256k1>,
        encryption_key: &Point<Secp256k1>,
        segment_size: &usize,
    ) -> (FirstMessage, Self) {
        let G = Point::<Secp256k1>::generator();

        let num_segments = SECRET_BIT_LENGTH / *segment_size; //TODO: asserty divisible or add segment
        let (segments, encryptions) = Msegmentation::to_encrypted_segments(
            secret,
            segment_size,
            num_segments,
            encryption_key,
            &G,
        );
        let proof = Proof::prove(&segments, &encryptions, &G, encryption_key, segment_size);

        // first message:
        let Q = Point::<Secp256k1>::generator() * secret;
        let D_vec: Vec<Point<Secp256k1>> = (0..num_segments)
            .map(|i| encryptions.DE[i].D.clone())
            .collect();
        let E_vec: Vec<Point<Secp256k1>> = (0..num_segments)
            .map(|i| encryptions.DE[i].E.clone())
            .collect();
        let E = Msegmentation::assemble_ge(&E_vec, segment_size);

        // TODO: zeroize

        (
            FirstMessage {
                segment_size: *segment_size,
                D_vec,
                range_proof: proof.bulletproof.clone(),
                Q,
                E,
                dlog_proof: proof.elgamal_enc_dlog.clone(),
            },
            VEShare {
                secret: secret.clone(),
                segments,
                encryptions,
                proof,
            },
        )
    }

    pub fn segment_k_proof(&self, segment_k: &usize) -> SegmentProof {
        SegmentProof {
            k: *segment_k,
            E_k: self.encryptions.DE[*segment_k].E.clone(),
            correct_enc_proof: self.proof.elgamal_enc[*segment_k].clone(),
        }
    }

    pub fn start_verify(
        first_message: &FirstMessage,
        encryption_key: &Point<Secp256k1>,
    ) -> Result<(), Errors> {
        Proof::verify_first_message(first_message, encryption_key)
    }

    pub fn verify_segment(
        first_message: &FirstMessage,
        segment: &SegmentProof,
        encryption_key: &Point<Secp256k1>,
    ) -> Result<(), Errors> {
        Proof::verify_segment(first_message, segment, encryption_key)
    }

    pub fn extract_secret(
        first_message: &FirstMessage,
        segment_proof_vec: &[SegmentProof],
        decryption_key: &Scalar<Secp256k1>,
    ) -> Result<Scalar<Secp256k1>, Errors> {
        let len = segment_proof_vec.len();
        if len != first_message.D_vec.len() {
            return Err(ErrorSegmentNum);
        }
        let elgamal_enc_vec = (0..len)
            .map(|i| Helgamal {
                D: first_message.D_vec[i].clone(),
                E: segment_proof_vec[i].E_k.clone(),
            })
            .collect::<Vec<Helgamal>>();
        let encryptions = Helgamalsegmented {
            DE: elgamal_enc_vec,
        };

        Msegmentation::decrypt(
            &encryptions,
            &Point::<Secp256k1>::generator(),
            decryption_key,
            &first_message.segment_size,
        )
    }
}

#[cfg(test)]
mod tests {
    use curv::elliptic::curves::{secp256_k1::Secp256k1, Point, Scalar};
    use grad_release::VEShare;
    use grad_release::SECRET_BIT_LENGTH;

    // simple usage example. two parties wish to exchange secrets in ~fair manner
    #[test]
    fn test_secret_exchange() {
        let segment_size = 8;
        // secret generation
        let secret_p1 = Scalar::<Secp256k1>::random();
        let secret_p2 = Scalar::<Secp256k1>::random();

        // enc/dec key pairs generation
        let p1_dec_key = Scalar::<Secp256k1>::random();
        let p1_enc_key = Point::<Secp256k1>::generator() * p1_dec_key.clone();
        let p2_dec_key = Scalar::<Secp256k1>::random();
        let p2_enc_key = Point::<Secp256k1>::generator() * p2_dec_key.clone();

        // p1 sends first message to p2
        let (p1_first_message, p1_ve_share) =
            VEShare::create(&secret_p1, &p2_enc_key, &segment_size);
        // p2 verify first message
        assert!(VEShare::start_verify(&p1_first_message, &p2_enc_key).is_ok());
        // p2 sends first message to p1
        let (p2_first_message, p2_ve_share) =
            VEShare::create(&secret_p2, &p1_enc_key, &segment_size);
        // p1 verify first message
        assert!(VEShare::start_verify(&p2_first_message, &p1_enc_key).is_ok());

        let mut p1_segment_proof_vec = Vec::new();
        let mut p2_segment_proof_vec = Vec::new();

        //send segment by segment:
        for k in 0..SECRET_BIT_LENGTH / segment_size {
            // p1 generates k segment
            let p1_seg_k_proof = p1_ve_share.segment_k_proof(&k);
            // p2 verify k segment
            assert!(
                VEShare::verify_segment(&p1_first_message, &p1_seg_k_proof, &p2_enc_key).is_ok()
            );
            p1_segment_proof_vec.push(p1_seg_k_proof);
            // p2 generates k segment
            let p2_seg_k_proof = p2_ve_share.segment_k_proof(&k);
            // p1 verify k segment
            assert!(
                VEShare::verify_segment(&p2_first_message, &p2_seg_k_proof, &p1_enc_key).is_ok()
            );
            p2_segment_proof_vec.push(p2_seg_k_proof);
        }

        // p1 and p2 can now extract the counter secrets.
        let secret_p1_extracted =
            VEShare::extract_secret(&p1_first_message, &p1_segment_proof_vec[..], &p2_dec_key)
                .expect("");
        assert_eq!(secret_p1_extracted, secret_p1);
        let secret_p2_extracted =
            VEShare::extract_secret(&p2_first_message, &p2_segment_proof_vec[..], &p1_dec_key)
                .expect("");
        assert_eq!(secret_p2_extracted, secret_p2);
    }
}
