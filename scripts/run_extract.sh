mkdir result
cd result
circom ../circuits/ExtractQnameTest.circom --r1cs --wasm -l ../../lib

cd ExtractQnameTest_js/
node generate_witness.js ExtractQnameTest.wasm ../../../inputs/ExtractInput.json witness.wtns

snarkjs groth16 setup ../ExtractQnameTest.r1cs ../../ptau/pot20_final.ptau ExtractQnameTest_0000.zkey
snarkjs zkey export verificationkey ExtractQnameTest_0000.zkey verification_key.json
snarkjs groth16 prove ExtractQnameTest_0000.zkey witness.wtns proof.json public.json