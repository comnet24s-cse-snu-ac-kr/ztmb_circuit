pragma circom 2.1.9;

// Get 255 bytes of DNS message and extract the QNAME from it
template DeserializePacket() {
    signal input packet[255];
    signal output qname[255];

    var keep_reading = 1;
    var skip_index = 0;

    signal character[255]; // intermediate variable

    for (var i = 0; i < 255; i++) {
        var index = i;

        keep_reading = keep_reading != 0 && (index != skip_index || packet[index] != 0);

        character[i] <-- (skip_index == index) * 46 + (skip_index != index) * packet[index];
        (character[i] - 46) * (character[i] - packet[index]) === 0;

        qname[i] <-- keep_reading * character[i] + (1 - keep_reading) * 46;
        (qname[i] - character[i]) * (qname[i] - 46) === 0;
        if (index == skip_index) {
            skip_index = packet[index] + skip_index + 1; // packet[index] must be a number
        }
    }
}

template ExtractQname(N) {
    signal input packet[N];
    signal output qname[255];

    component deserialize = DeserializePacket();
    for (var i = 12; i < 267; i++) {
        deserialize.packet[i-12] <== packet[i];
    }
    qname <== deserialize.qname;
}

// component main = ExtractQname();
// snarkjs groth16 setup ExtractQnameTest.r1cs pot12_final.ptau multiplier2_0000.zkey
// snarkjs zkey contribute multiplier2_0000.zkey multiplier2_0001.zkey --name="1st Contributor Name" -v
