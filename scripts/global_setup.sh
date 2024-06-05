mkdir ptau
cd ptau/

snarkjs powersoftau new bn128 $1 pot$1_0000.ptau -v
snarkjs powersoftau prepare phase2 pot$1_0000.ptau pot$1_final.ptau -v