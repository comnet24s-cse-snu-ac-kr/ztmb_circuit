pragma circom 2.1.9;

include "chacha20/chacha20-bits.circom";
include "../Helper.circom";
include "../Encoding0x20.circom";
include "../ReplaceQname.circom";
include "../ExtractQname.circom";
include "../EncryptPacket.circom";

template TLSChaChaProof() {
    // Encryption
    signal input key[32]; //** Byte array, 256 bit
    signal input nonce[12]; //** Byte array, 96 bit
    signal input counter[4]; //** Byte array, 32 bit
    signal input packet[512]; //** ASCII array + padding 0, 4096 bit
    signal input ciphertext[512]; //** Byte array, 4096 bit

    // Extract qname
    component extract_qname = ExtractQname(512);
    extract_qname.packet <== packet;

    signal qname[255] <== extract_qname.qname;

    // Signature
    

    // 0x20
    component encoding0x20 = Encoding0x20();
    encoding0x20.s <== qname;
    signal qname_encoded[255] <== encoding0x20.encodedStr;

    // Replace qname
    component replace_qname = ReplaceQname(512);
    replace_qname.in_packet <== packet;
    replace_qname.qname <== qname_encoded;

    signal packet_encoded[512] <== replace_qname.out_packet;

    // Encrypt
    component chacha20 = ChaCha20(128, 32);
    component num2Bits[8];
    for(var i=0; i<8; i++) {
        num2Bits[i] = MultiNum2Bits(4);
        num2Bits[i].in[0] <== key[i*4];
        num2Bits[i].in[1] <== key[i*4+1];
        num2Bits[i].in[2] <== key[i*4+2];
        num2Bits[i].in[3] <== key[i*4+3];
        for(var j=0; j<32; j++) {
            chacha20.key[i][j] <== num2Bits[i].out[j];
        }
    }
    component num2Bits2[3];
    for(var i=0; i<3; i++) {
        num2Bits2[i] = MultiNum2Bits(4);
        num2Bits2[i].in[0] <== nonce[i*4];
        num2Bits2[i].in[1] <== nonce[i*4+1];
        num2Bits2[i].in[2] <== nonce[i*4+2];
        num2Bits2[i].in[3] <== nonce[i*4+3];
        for(var j=0; j<32; j++) {
            chacha20.nonce[i][j] <== num2Bits2[i].out[j];
        }
    }
    component num2Bits3;
    num2Bits3 = MultiNum2Bits(4);
    num2Bits3.in[0] <== counter[0];
    num2Bits3.in[1] <== counter[1];
    num2Bits3.in[2] <== counter[2];
    num2Bits3.in[3] <== counter[3];
    chacha20.counter <== num2Bits3.out;
    
    component num2Bits4[128];
    for(var i=0; i<128; i++) {
        num2Bits4[i] = MultiNum2Bits(4);
        num2Bits4[i].in[0] <== packet_encoded[i*4];
        num2Bits4[i].in[1] <== packet_encoded[i*4+1];
        num2Bits4[i].in[2] <== packet_encoded[i*4+2];
        num2Bits4[i].in[3] <== packet_encoded[i*4+3];
        for(var j=0; j<32; j++) {
            chacha20.in[i][j] <== num2Bits4[i].out[j];
        }
    }

    component num2Bits5[128];
    for(var i=0; i<128; i++) {
        num2Bits5[i] = MultiNum2Bits(4);
        num2Bits5[i].in[0] <== ciphertext[i*4];
        num2Bits5[i].in[1] <== ciphertext[i*4+1];
        num2Bits5[i].in[2] <== ciphertext[i*4+2];
        num2Bits5[i].in[3] <== ciphertext[i*4+3];
        for(var j=0; j<32; j++) {
            chacha20.out[i][j] === num2Bits5[i].out[j];
        }
    }
}