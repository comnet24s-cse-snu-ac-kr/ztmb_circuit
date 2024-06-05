mkdir result
cd result
circom ../../TLSCHACHAProof.circom --r1cs --wasm -l ../../lib


cd TLSCHACHAProof_js/
node generate_witness.js TLSCHACHAProof.wasm ../../../inputs/input.json witness.wtns

snarkjs groth16 setup ../TLSCHACHAProof.r1cs ../../ptau/pot20_final.ptau TLSCHACHAProof_0000.zkey
snarkjs zkey export verificationkey TLSCHACHAProof_0000.zkey verification_key.json
snarkjs groth16 prove TLSCHACHAProof_0000.zkey witness.wtns proof.json public.json