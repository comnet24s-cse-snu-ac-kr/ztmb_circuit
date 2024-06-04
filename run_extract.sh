circom ExtractQnameTest.circom --r1cs --wasm -l lib
cd ExtractQnameTest_js/
node generate_witness.js ExtractQnameTest.wasm ../ExtractInput.json witness.wtns
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau prepare phase2 pot12_0000.ptau pot12_final.ptau -v
snarkjs groth16 setup ../ExtractQnameTest.r1cs pot12_final.ptau multiplier2_0000.zkey
snarkjs zkey export verificationkey multiplier2_0000.zkey verification_key.json
snarkjs groth16 prove multiplier2_0000.zkey witness.wtns proof.json public.json
