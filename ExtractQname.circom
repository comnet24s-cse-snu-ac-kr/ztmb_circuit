pragma circom 2.0.0;

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

        qname[i] <-- keep_reading * character[i];
        (qname[i] - character[i]) * (qname[i]) === 0;

        skip_index = packet[index] + skip_index + 1; // packet[index] must be a number
    }
}

template ExtractQname(N) {
    signal input packet[N];
    signal output qname[255];

    component deserialize = DeserializePacket();
    for (var i = 16; i < 271; i++) {
        deserialize.packet[i-16] <== packet[i];
    }
    qname <== deserialize.qname;
}

// component main = ExtractQname();