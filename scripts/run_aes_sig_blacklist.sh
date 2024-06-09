mkdir result
cd result
circom ../../circuits/TLSAESSigProof.circom --r1cs --wasm -l ../../lib

cd TLSAESSigProof_js/
node generate_witness.js TLSAESSigProof.wasm ../../../inputs/sig_blacklist_input.json witness.wtns

snarkjs groth16 setup ../TLSAESSigProof.r1cs ../../ptau/pot20_final.ptau TLSAESSigProof_0000.zkey
snarkjs zkey export verificationkey TLSAESSigProof_0000.zkey verification_key.json
snarkjs groth16 prove TLSAESSigProof_0000.zkey witness.wtns proof.json public.json
