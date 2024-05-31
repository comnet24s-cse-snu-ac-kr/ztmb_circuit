pragma circom 2.1.9;

include "../Helper.circom";
include "../Encoding0x20.circom";
include "../ReplaceQname.circom";
include "../ExtractQname.circom";
include "../EncryptPacket.circom";

template TLSAESProof() {
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
    component packet_encryption = EncryptPacket();
    packet_encryption.key_byte <== key;
    packet_encryption.nonce_byte <== nonce;
    packet_encryption.counter_byte <== counter;
    packet_encryption.in_byte <== packet_encoded;

    ciphertext === packet_encryption.out_byte;

}


