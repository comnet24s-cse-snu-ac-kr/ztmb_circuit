const JSONbig = require("json-bigint-native");
const path = require("path");
const Scalar = require("ffjavascript").Scalar;
const newMemEmptyTrie = require("circomlibjs").newMemEmptyTrie;
const buildPoseidon = require("circomlibjs").buildPoseidon;
const crypto = require("crypto");

const nLevels = 10; // TODO: Modify this.

async function generateInclusion(tree, _key) {
    const key = tree.F.e(_key);
    const res = await tree.find(key);

    let siblings = res.siblings;
    for (let i=0; i<siblings.length; i++) siblings[i] = tree.F.toObject(siblings[i]);
    while (siblings.length<nLevels) siblings.push(0);

    const jsono = {
        enabled: 1,
        fnc: 0,
        root: tree.F.toObject(tree.root),
        siblings: siblings,
        oldKey: 0,
        oldValue: 0,
        isOld0: 0,
        key: tree.F.toObject(key),
        keyNonce: tree.F.toObject(123),
        value: tree.F.toObject(res.foundValue)
    };

    const json = JSONbig.stringify(jsono);
    const withStrings = JSONbig.stringify(JSONbig.parse(json, (key, val) => (
        typeof val !== 'object' && val !== null ? String(val) : val
    )));
    console.log(withStrings);
}

async function generateExclusion(tree, _key) {
    const key = tree.F.e(_key);
    const res = await tree.find(key);

    let siblings = res.siblings;
    for (let i=0; i<siblings.length; i++) siblings[i] = tree.F.toObject(siblings[i]);
    while (siblings.length<nLevels) siblings.push(0);

    const jsono = {
        enabled: 1,
        fnc: 1,
        root: tree.F.toObject(tree.root),
        siblings: siblings,
        oldKey: res.isOld0 ? 0 : tree.F.toObject(res.notFoundKey),
        oldValue: res.isOld0 ? 0 : tree.F.toObject(res.notFoundValue),
        isOld0: res.isOld0 ? 1 : 0,
        key: tree.F.toObject(key),
        keyNonce: tree.F.toObject(123),
        value: 0
    }

    const json = JSONbig.stringify(jsono);
    const withStrings = JSONbig.stringify(JSONbig.parse(json, (key, val) => (
      typeof val !== 'object' && val !== null ? String(val) : val
    )));
    console.log(withStrings);
}

async function generateExclusion_signature(tree, _key, check_sig) {

    // poseidon value for 'check_signature'
    poseidon = await buildPoseidon();
    F = poseidon.F;
    //const res2 = poseidon([1,2]);    // !!! string to byte array?
    const b = Buffer.from(check_sig, "utf8");
    const hash = crypto.createHash("sha256")
        .update(b)
        .digest("hex");
    const res_p = BigInt(`0x${hash.substring(0,16)}`);
    const res_poseidon = poseidon([res_p,2]);                 // 2 - random secret

    const key = tree.F.e(res_poseidon); // look for it in the SMT
    const res = await tree.find(key);

    let siblings = res.siblings;
    for (let i=0; i<siblings.length; i++) siblings[i] = tree.F.toObject(siblings[i]);
    while (siblings.length<nLevels) siblings.push(0);

    const jsono = {
        enabled: 1,
        fnc: 1,
        root: tree.F.toObject(tree.root),
        siblings: siblings,
        oldKey: res.isOld0 ? 0 : tree.F.toObject(res.notFoundKey),
        oldValue: res.isOld0 ? 0 : tree.F.toObject(res.notFoundValue),
        isOld0: res.isOld0 ? 1 : 0,
        key: tree.F.toObject(key),
        keyNonce: tree.F.toObject(123),
        value: 0,

        // inputs for Poseidon
        p_secret : 2,
        p_key : res_p,
        nullifier: F.toObject(res_poseidon),
    }

    const json = JSONbig.stringify(jsono);
    const withStrings = JSONbig.stringify(JSONbig.parse(json, (key, val) => (
      typeof val !== 'object' && val !== null ? String(val) : val
    )));
    console.log(withStrings);
}

// TODO: Modify this.
const main = async() => {
  let Fr;
  let tree;
  let poseidon;

  tree = await newMemEmptyTrie();
  Fr = tree.F;
  // await tree.insert(7,77);
  // await tree.insert(8,88);
  // await tree.insert(32,3232);

  for( var index = 0; index < 5; index++ ) {
    // generate sha256 signature
    const testStr = "attacker_dns_tunneling_" + index;
    const b = Buffer.from(testStr, "utf8");
    const hash = crypto.createHash("sha256")
        .update(b)
        .digest("hex");
    const hash_bi = BigInt(`0x${hash.substring(0,16)}`);

    // poseidon
    poseidon = await buildPoseidon();
    Fp = poseidon.F;
    const res2 = poseidon([hash_bi]); //should be value of signature
    
    await tree.insert(res2, index);
  }

  //generateInclusion(tree, 7);
  generateExclusion_signature(tree, 9, "valid_user");
  //generateExclusion_signature(tree, 9, "attacker_dns_tunneling_0");
};

main();
