pragma circom 2.1.9;
include "circomlib/circuits/bitify.circom";

template MultiNum2Bits(N) {
    signal input in[N];
    signal output out[N*8];
    component num2Bits[N];

    for(var i=0; i<N; i++) {
        num2Bits[i] = Num2Bits(8);
        num2Bits[i].in <== in[i];
        for(var j=0; j<8; j++) {
            out[i*8 + j] <== num2Bits[i].out[j];
        }
    }
}


template MultiBitstoNum(N) {
    signal input in[N*8];
    signal output out[N];
    component bits2Num[N];

    for(var i=0; i<N; i++) {
        bits2Num[i] = Bits2Num(8);
        for(var j=0; j<8; j++) {
            bits2Num[i].in[j] <== in[i*8 + j];
        }
        out[i] <== bits2Num[i].out;
    }
}