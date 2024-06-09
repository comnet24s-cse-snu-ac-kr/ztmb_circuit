#!/bin/bash

# 결과를 저장할 CSV 파일 초기화
echo "folder,file,total_sec_witness,total_sec_prove,total_sec_verify" > time_measurements.csv

pwd

for folder in "benign" "dns2tcp" "dnscapy" "iodine" "tuns"; do
    for file in "inputs/$folder"/*; do
        echo "Processing file: $file"
        cd result/TLSAESProof_js
        
        # Witness generation
        runtime=$( { time node generate_witness.js TLSAESProof.wasm "../../$file" witness.wtns 1>/dev/null 2>&1; } 2>&1 | awk '/real/{print $2}' )
        min=$(echo $runtime | cut -d'm' -f1)
        sec=$(echo $runtime | cut -d's' -f1 | cut -d'm' -f2)
        total_sec_witness=$(echo "scale=3; $min*60 + $sec" | bc)

        # Proof generation
        runtime=$( { time snarkjs groth16 prove TLSAESProof_0000.zkey witness.wtns proof.json public.json 1>/dev/null 2>&1; } 2>&1 | awk '/real/{print $2}' )
        min=$(echo $runtime | cut -d'm' -f1)
        sec=$(echo $runtime | cut -d's' -f1 | cut -d'm' -f2)
        total_sec_prove=$(echo "scale=3; $min*60 + $sec" | bc)

        # Verification
        runtime=$( { time snarkjs groth16 verify verification_key.json public.json proof.json 1>/dev/null 2>&1; } 2>&1 | awk '/real/{print $2}' )
        min=$(echo $runtime | cut -d'm' -f1)
        sec=$(echo $runtime | cut -d's' -f1 | cut -d'm' -f2)
        total_sec_verify=$(echo "scale=3; $min*60 + $sec" | bc)

        # Write results to CSV file
        echo "$folder,$file,$total_sec_witness,$total_sec_prove,$total_sec_verify" >> time_measurements.csv

        cd -
    done
done


echo "Data has been written to time_measurements.csv"
