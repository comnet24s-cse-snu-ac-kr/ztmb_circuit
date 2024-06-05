# ztmb_circuit
## Prerequisites
- circom 2.1.9
- node 20.13.1
- snarkjs 0.7.4

## Ptau Global Ceremony
To initiate the setup for global parameters, navigate to the scripts directory and execute the setup scripts. This step is essential and must be completed before running any scripts related to proof generation.

``` bash
cd scripts
./global_setup.sh 12
./global_setup.sh 20
```

## Proof Generation
Navigate to the scripts directory to run the AES proof generation script. The generated proofs(proof.json) and their corresponding public output(public.json) will be stored in the result/TLSAESProof_js directory. 

``` bash
cd scripts
./run_aes.sh
```
> Note : The generation of ChaCha proofs is currently in progress (WIP).

## Module Test
Test various modules by navigating to the scripts directory and executing the respective scripts. Replace {module_name} with one of the following: encoding, encrypt, extract, replace. The outputs, including proofs and public information, will be stored in the result directory.

```bash
cd scripts
./run_{module_name}.sh
```

> Note: Ensure that {module_name} is replaced with the actual name of the module you wish to test.

