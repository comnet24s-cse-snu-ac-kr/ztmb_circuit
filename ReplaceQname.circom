pragma circom 2.0.0;

template ReplaceQname(N) {
    signal input qname[255];
    signal input in_packet[N];
    signal output out_packet[N];

    for (var i=0; i<N; i++) {
        if (i>= 16 && i < 271) {
            out_packet[i] <-- (qname[i-16] == 42) * in_packet[i] + (qname[i-16] != 42) * qname[i-16];
            (out_packet[i] - qname[i-16]) * (out_packet[i] - in_packet[i]) === 0;
        } else {
            out_packet[i] <== in_packet[i];
        }
    }
}

// component main = ReplaceQname();