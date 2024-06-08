pragma circom 2.1.9;

include "../circuits/Helper.circom";
include "../circuits/Encoding0x20.circom";
include "../circuits/ReplaceQname.circom";
include "../circuits/ExtractQname.circom";
include "../circuits/EncryptPacket.circom";

//=== library for Sig
include "circomlib/circuits/smt/smtverifier.circom";
include "circomlib/circuits/poseidon.circom";
include "circomlib/circuits/comparators.circom";

template TLSAESProof(nLevels) {
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

    //===== Signature ===========================
    signal input enabled_s;
    signal input root_s;
    signal input siblings_s[nLevels];
    signal input oldKey_s;
    signal input oldValue_s;
    signal input isOld0_s;
    signal input key_s;
    signal input keyNonce_s;
    signal input value_s;
    signal input fnc_s;

	signal input p_secret_s;
	signal input p_key_s;
	signal input nullifier_s;

    var i;

	component nullifierCmp = Poseidon(2);
    nullifierCmp.inputs[0] <== p_key_s;
	nullifierCmp.inputs[1] <== p_secret_s;

	component nullifierCheck = IsEqual();
	nullifierCheck.in[0] <== nullifierCmp.out;
	nullifierCheck.in[1] <== nullifier_s;
	nullifierCheck.out === 1;

    component smt = SMTVerifier(nLevels);
    smt.enabled <== enabled_s;
    smt.root <== root_s;
    for (i=0; i<nLevels; i++) smt.siblings[i] <== siblings_s[i];
    smt.oldKey <== oldKey_s;
    smt.oldValue <== oldValue_s;
    smt.isOld0 <== isOld0_s;
    smt.key <== key_s + keyNonce_s;
    smt.value <== value_s;
    smt.fnc <== fnc_s;
    //===== End of Signature ===========================

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

component main = TLSAESProof(10);