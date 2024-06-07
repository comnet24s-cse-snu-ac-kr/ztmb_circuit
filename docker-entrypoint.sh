#!/bin/sh

set -e

INPUT_PATH=${INPUT_PATH:="../../../inputs/input.json"}

FILENAME=$(echo ${INPUT_PATH} | rev | cut -d '/' -f 1 | rev)
WTNS_TIME=$(time -f '%e' node TLSAESProof_js/generate_witness.js TLSAESProof_js/TLSAESProof.wasm ${INPUT_PATH} witness.wtns 2>&1)
PROVE_TIME=$(time -f '%e' snarkjs groth16 prove TLSAESProof_0000.zkey witness.wtns proof.json public.json 2>&1)
VERIFY_TIME=$(time -f '%e' snarkjs groth16 verify verification_key.json public.json proof.json 2>&1)

cat << EOF
${FILENAME},${WTNS_TIME},${PROVE_TIME},${VERIFY_TIME}
EOF
