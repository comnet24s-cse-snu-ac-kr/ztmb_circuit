pragma circom 2.1.9;
include "./Helper.circom";
include "aes-circom/circuits/aes_ctr.circom";

template EncryptPacket() {
    signal input in_byte[512];
    signal input key_byte[32];
    signal input nonce_byte[12];
    signal input counter_byte[4];

    // the key, iv & startCounter are private inputs
    // they must be specified by the client 
    signal key[32 * 8];
    signal nonce[12 * 8];
    signal counter[4 * 8];
    // the ciphertext is public input
    // so the witness can check the right data was sent to the circuit
    signal in[4096];
    signal out[4096];
    signal output out_byte[512];

    component num2Bits[5];
    num2Bits[0] = MultiNum2Bits(512);
    num2Bits[0].in <== in_byte;
    in <== num2Bits[0].out;
    num2Bits[1] = MultiNum2Bits(32);
    num2Bits[1].in <== key_byte;
    key <== num2Bits[1].out;
    num2Bits[2] = MultiNum2Bits(12);
    num2Bits[2].in <== nonce_byte;
    nonce <== num2Bits[2].out;
    num2Bits[3] = MultiNum2Bits(4);
    num2Bits[3].in <== counter_byte;
    counter <== num2Bits[3].out;
    

    // AES CTR decryption
    component aes = AES_CTR(4096);
    for(var i = 0; i < 32 * 8; i++) {
        aes.K1[i] <== key[i];
    }

    // set counter
    for(var i = 0; i < 12 * 8; i++) {
        aes.CTR[i] <== nonce[i];
    }
    for(var i = 0; i < 4 * 8; i++) {
        aes.CTR[i + 12*8] <== counter[i];
    }

    for(var i = 0; i < 4096; i++) {
        aes.MSG[i] <== in[i];
    }

    for(var i = 0; i < 4096; i++) {
        out[i] <== aes.CT[i];
        }

    component bits2Num = MultiBitstoNum(512);
    bits2Num.in <== out;
    out_byte <== bits2Num.out;
}