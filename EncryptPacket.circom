pragma circom 2.0.0;

template EncryptPacket(N, BITS_PER_WORD) {

    signal input in_byte[N];
    signal input key_byte[32];
    signal input nonce_byte[12];
    signal input counter_byte[4];

    // the key, iv & startCounter are private inputs
    // they must be specified by the client 
    signal key[32 * BITS_PER_WORD];
    signal nonce[12 * BITS_PER_WORD];
    signal counter[4 * BITS_PER_WORD];
    // the ciphertext is public input
    // so the witness can check the right data was sent to the circuit
    signal in[N*8];
    signal out[N*8];
    signal output out_byte[N];

    component num2Bits[5];
    num2Bits[0] = MultiNum2Bits(N);
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
    component aes = AES_CTR(N*8);
    for(var i = 0; i < 32 * BITS_PER_WORD; i++) {
        aes.K1[i] <== key[i];
    }

    // set counter
    for(var i = 0; i < 12 * BITS_PER_WORD; i++) {
        aes.CTR[i] <== nonce[i];
    }
    for(var i = 0; i < 4 * BITS_PER_WORD; i++) {
        aes.CTR[i + 12*BITS_PER_WORD] <== counter[i];
    }

    for(var i = 0; i < N*8; i++) {
        aes.MSG[i] <== in[i];
    }

    for(var i = 0; i < N*8; i++) {
        out[i] <== aes.CT[i];
        }

    component bits2Num = MultiBitstoNum(N);
    bits2Num.in <== out;
    out_byte <== bits2Num.out;
}