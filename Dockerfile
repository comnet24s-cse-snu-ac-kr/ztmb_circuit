FROM rust:alpine AS circom-builder

RUN apk add --no-cache \
  curl \
  vim \
  git \
  gcc \
  musl-dev

RUN git clone https://github.com/iden3/circom.git && \
    cd circom && \
    cargo build --release && \
    cargo install --path circom

FROM node:alpine

COPY --from=circom-builder /usr/local/cargo/bin/circom /bin/

RUN npm install -g snarkjs

WORKDIR /app

ARG LV=20

COPY ./scripts/global_setup.sh ./
RUN /app/global_setup.sh ${LV}

COPY . .

RUN circom circuits/TLSAESProof.circom --r1cs --wasm -l lib \
  && snarkjs groth16 setup TLSAESProof.r1cs ptau/pot20_final.ptau TLSAESProof_0000.zkey \
  && snarkjs zkey export verificationkey TLSAESProof_0000.zkey verification_key.json

ENTRYPOINT ["/app/docker-entrypoint.sh"]
