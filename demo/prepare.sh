#!/bin/sh

circom ../circuits/TLSAESSigProof.circom --r1cs --wasm -l ../lib
snarkjs groth16 setup TLSAESSigProof.r1cs ../ptau/pot20_final.ptau TLSAESSigProof_0000.zkey
snarkjs zkey export verificationkey TLSAESSigProof_0000.zkey verification_key.json
