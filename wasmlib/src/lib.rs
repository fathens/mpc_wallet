mod bridge_generated; /* AUTO INJECTED BY flutter_rust_bridge. This line may not be accurate, and you can change it according to your needs. */
mod api;
mod utils;
mod gg20;
mod centipede;
mod curv;
mod utilities;
mod zk_paillier;
mod paillier;
mod round_based;
mod bulletproof;

#[derive(Copy, PartialEq, Eq, Clone, Debug)]
pub enum Error {
    InvalidKey,
    InvalidSS,
    InvalidCom,
    InvalidSig,
    Phase5BadSum,
    Phase6Error,
}
