mkdir result
cd result
circom ../circuits/ReplaceQnameTest.circom --r1cs --wasm -l ../../lib

cd ReplaceQnameTest_js/
node generate_witness.js ReplaceQnameTest.wasm ../../../inputs/ReplaceInput.json witness.wtns

snarkjs groth16 setup ../ReplaceQnameTest.r1cs ../../ptau/pot20_final.ptau ReplaceQnameTest_0000.zkey
snarkjs zkey export verificationkey ReplaceQnameTest_0000.zkey verification_key.json
snarkjs groth16 prove ReplaceQnameTest_0000.zkey witness.wtns proof.json public.json