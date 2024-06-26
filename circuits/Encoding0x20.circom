pragma circom 2.1.9;
include "circomlib/circuits/poseidon.circom";
include "@zk-email/circuits/utils/bytes.circom";

template ExtendedPoseidon(n) {
    signal input in[n];
    signal output out;

    component packer = PackBytes(n);
    packer.in <== in;
    var maxInts = computeIntChunkLength(n);

    component hasher = Poseidon(maxInts);
    for (var i = 0; i < maxInts; i++) {
        hasher.inputs[i] <== packer.out[i];
    }
    out <== hasher.out;
}


template Encoding0x20() {
    signal input s[255];
    signal output encodedStr[255];
    
    component hasher = ExtendedPoseidon(255);
    for (var i = 0; i < 255; i++) {
        hasher.in[i] <== s[i];
    }
    signal hash <== hasher.out;
    
    signal lower[255], upper[255];
    signal beUpper[255], beLower[255];
    for (var i = 0; i < 255; i++) {
        var hashBit = (hash >> i) & 1; // 거꾸로 하고있음 나중에 수정

        beLower[i] <-- (s[i] <= 90 && s[i] >= 65 && hashBit == 0);
        beLower[i] * (beLower[i] - 1) === 0;

        beUpper[i] <-- (s[i] <= 122 && s[i] >= 97) * (hashBit == 1);
        beUpper[i] * (beUpper[i] - 1) === 0;

        encodedStr[i] <== beLower[i] * 0x20 + beUpper[i] * -0x20 + s[i];
    }
}


