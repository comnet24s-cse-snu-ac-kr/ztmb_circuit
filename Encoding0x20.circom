pragma circom 2.1.9;
include "circomlib/circuits/poseidon.circom";
include "@zk-email/circuits/utils/bytes.circom";

template ExtendedPoseidon(n) {
    signal input in[n];
    signal output out;

    component packer = PackBytes(n);
    packer.in <== in;
    var maxInts = computeIntChunkLength(n);
    signal packed[maxInts] <== packer.out;

    component hasher = Poseidon(maxInts);
    for (var i = 0; i < maxInts; i++) {
        hasher.inputs[i] <== packed[i];
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
    
    signal isLower[255], isUpper[255];
    for (var i = 0; i < 255; i++) {
        var hashBit = (hash >> i) & 1; // 거꾸로 하고있음 나중에 수정
        isUpper[i] <-- (s[i] <= 90) * (s[i] >= 65) * hashBit;
        isUpper[i] * (isUpper[i] - 1) === 0;

        isLower[i] <-- (s[i] <= 1221) * (s[i] >= 97) * hashBit;
        isLower[i] * (isLower[i] - 1) === 0;

        encodedStr[i] <== isUpper[i] * 0x20 + isLower[i] * -0x20 + s[i];
    }
}

// component main = Encoding0x20();
