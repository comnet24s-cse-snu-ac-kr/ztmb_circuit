#!/bin/sh

INPUT="./benign.json"
PROOF="./wrong_proof.json"

echo "----- Processing '${INPUT}' -----"
echo -n "Generating witness... "
if `time -f '%e' -o wtns.time node TLSAESSigProof_js/generate_witness.js TLSAESSigProof_js/TLSAESSigProof.wasm ${INPUT} witness.wtns &> wtns.log`; then
  echo "Done."
else 
  echo "Failed"
  cat wtns.log 1>&2
  exit 1
fi

echo -n "Generating prove... "
time -f '%e' -o prove.time snarkjs groth16 prove TLSAESSigProof_0000.zkey witness.wtns proof.json public.json &> prove.log
echo "Done."

echo -n "Verifying '${PROOF}'... "
time -f '%e' -o verify.time snarkjs groth16 verify verification_key.json public.json ${PROOF} &> verify.log
echo "Done."

WTNS_TIME=$(cat wtns.time | tail -n1)
PROVE_TIME=$(cat prove.time | tail -n1)
VERIFY_TIME=$(cat verify.time | tail -n1)

echo
echo "----- Result -----"
cat << EOF | column -s ',' -t
WITNESS TIME (seconds),PROVE TIME (seconds),VERIFY TIME (seconds),VERIFY RESULT
${WTNS_TIME},${PROVE_TIME},${VERIFY_TIME},$(cat verify.log)
EOF
