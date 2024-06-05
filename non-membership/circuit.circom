pragma circom 2.0.0;

include "./circuits/smt/smtverifier.circom";
include "./circuits/poseidon.circom";
include "./circuits/comparators.circom";

template ClaimSMT(nLevels) {
    signal input enabled;
    signal input root;
    signal input siblings[nLevels];
    signal input oldKey;
    signal input oldValue;
    signal input isOld0;
    signal input key;
    signal input keyNonce;
    signal input value;
    signal input fnc;

    // poseidon - input
	signal private input p_secret;
	signal private input p_key;
	signal input nullifier;


    var i;

    // poseidon
    component nullifierCmp = Poseidon(2, 6, 8, 57);
	nullifierCmp.inputs[0] <== p_key;
	nullifierCmp.inputs[1] <== p_secret;

	component nullifierCheck = IsEqual();
	nullifierCheck.in[0] <== nullifierCmp.out;
	nullifierCheck.in[1] <== nullifier;
	nullifierCheck.out === 1;


    component smt = SMTVerifier(nLevels);
    smt.enabled <== enabled;
    smt.root <== root;
    for (i=0; i<nLevels; i++) smt.siblings[i] <== siblings[i];
    smt.oldKey <== oldKey;
    smt.oldValue <== oldValue;
    smt.isOld0 <== isOld0;
    smt.key <== key + keyNonce;
    smt.value <== value;
    smt.fnc <== fnc;
}

component main {public [
    enabled, root, siblings, oldKey, oldValue, isOld0, key, value, fnc
]} = ClaimSMT(10);
