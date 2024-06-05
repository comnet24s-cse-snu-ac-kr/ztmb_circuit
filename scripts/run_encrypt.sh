mkdir result
cd result
circom ../circuits/EncryptPacketTest.circom --r1cs --wasm -l ../../lib

cd EncryptPacketTest_js/
node generate_witness.js EncryptPacketTest.wasm ../../../inputs/EncryptInput.json witness.wtns

snarkjs groth16 setup ../EncryptPacketTest.r1cs ../../ptau/pot20_final.ptau EncryptPacketTest_0000.zkey
snarkjs zkey export verificationkey EncryptPacketTest_0000.zkey verification_key.json
snarkjs groth16 prove EncryptPacketTest_0000.zkey witness.wtns proof.json public.json