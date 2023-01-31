use wasm_bindgen::prelude::*;
use mpc_ecdsa_wasm::keygen;

// When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
// allocator.
#[cfg(feature = "wee_alloc")]
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

#[wasm_bindgen]
extern {
    fn alert(s: &str);
}

#[wasm_bindgen]
pub fn greet() {
    alert("Hello, wasmlib!");
}

#[wasm_bindgen]
pub fn calc_add(a: i32, b: i32) -> i32 {
    return a + b;
}

#[wasm_bindgen]
pub fn sample_key(a: i32, b: i32) -> i32 {
    return keygen::start_keygen(a, b).unwrap();
}
