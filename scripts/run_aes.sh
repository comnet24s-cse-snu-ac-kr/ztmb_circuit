mkdir result
cd result
circom ../../circuits/TLSAESProof.circom --r1cs --wasm -l ../../lib

cd TLSAESProof_js/
node generate_witness.js TLSAESProof.wasm ../../../inputs/input.json witness.wtns

snarkjs groth16 setup ../TLSAESProof.r1cs ../../ptau/pot20_final.ptau TLSAESProof_0000.zkey
snarkjs zkey export verificationkey TLSAESProof_0000.zkey verification_key.json
snarkjs groth16 prove TLSAESProof_0000.zkey witness.wtns proof.json public.json
