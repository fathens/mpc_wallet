use std::collections::HashMap;
use multi_party_ecdsa::protocols::multi_party_ecdsa::gg_2020;
use gg_2020::state_machine::keygen::Keygen;
use gg_2020::party_i::{KeyGenBroadcastMessage1, KeyGenDecommitMessage1 };
use multi_party_ecdsa::protocols::multi_party_ecdsa::gg_2020::state_machine::sign::ProceedError::Round1;
use std::sync::{Mutex, Arc};
use once_cell::sync::Lazy;
use anyhow::Result;

static KEY_VALUE: Lazy<Mutex<HashMap<u8, i32>>> = Lazy::new(|| Mutex::new(
    HashMap::new()
));

pub fn start_keygen(a: i32, b: i32) -> Result<i32> {
    let key = 0;
    let mut kv = KEY_VALUE.lock().unwrap();
    if let Some(prev) = kv.get(&key) {
        let next = prev + a - b;
        kv.insert(key, next);
        return Ok(next);
    }
    let next = a - b;
    kv.insert(key, next);
    Ok(next)
}
