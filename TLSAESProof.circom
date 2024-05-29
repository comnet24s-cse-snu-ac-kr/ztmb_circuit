pragma circom 2.0.0;

include "aes-circom/circuits/aes_ctr.circom";
include "circomlib/circuits/bitify.circom";
include "hash_circuits/circuits/sha2/sha384/sha384_hash_bytes.circom";
include "../Helper.circom";
include "../Encoding0x20.circom";
include "../ReplaceQname.circom";
include "../ExtractQname.circom";
include "../EncryptPacket.circom";

template TLSProofGen() {
    // Encryption
    signal input key[32]; //** Byte array, 256 bit
    signal input nonce[12]; //** Byte array, 96 bit
    signal input counter[4]; //** Byte array, 32 bit
    signal input packet[464]; //** ASCII array + padding 0, 4096 bit
    signal input ciphertext[512]; //** Byte array, 4096 bit

    // Extract qname
    component extract_qname = ExtractQname(464);
    extract_qname.packet <== packet;

    signal qname[255] <== extract_qname.qname;

    // 0x20
    component encoding0x20 = Encoding0x20();
    encoding0x20.s <== qname;
    signal qname_encoded[255] <== encoding0x20.encodedStr;

    // Replace qname
    component replace_qname = ReplaceQname(464);
    replace_qname.in_packet <== packet;
    replace_qname.qname <== qname_encoded;

    signal packet_encoded[464] <== replace_qname.out_packet;

    // MAC
    component sha384 = Sha384_hash_bytes_digest(464);
    sha384.inp_bytes <== packet_encoded;

    signal packet_encoded_with_mac[512];
    for(var i=0; i<464; i++) {
        packet_encoded_with_mac[i] <== packet_encoded[i];
    }
    for(var i=0; i<48; i++) {
        packet_encoded_with_mac[464+i] <== sha384.hash_bytes[i];
    }

    // Encrypt
    component packet_encryption = EncryptPacket(512, 8);
    packet_encryption.key_byte <== key;
    packet_encryption.nonce_byte <== nonce;
    packet_encryption.counter_byte <== counter;
    packet_encryption.in_byte <== packet_encoded_with_mac;

    ciphertext === packet_encryption.out_byte;
}


component main {public [ciphertext]} = TLSProofGen();