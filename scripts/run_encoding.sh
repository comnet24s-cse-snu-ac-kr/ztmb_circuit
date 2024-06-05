mkdir result
cd result
circom ../circuits/Encoding0x20Test.circom --r1cs --wasm -l ../../lib

cd Encoding0x20Test_js/
node generate_witness.js Encoding0x20Test.wasm ../../../inputs/EncodingInput.json witness.wtns

snarkjs groth16 setup ../Encoding0x20Test.r1cs ../../ptau/pot20_final.ptau Encoding0x20Test_0000.zkey
snarkjs zkey export verificationkey Encoding0x20Test_0000.zkey verification_key.json
snarkjs groth16 prove Encoding0x20Test_0000.zkey witness.wtns proof.json public.json