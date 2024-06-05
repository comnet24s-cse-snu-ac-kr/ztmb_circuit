FROM rust:alpine

WORKDIR /

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

RUN apk add --no-cache \
  nodejs \
  npm

RUN npm install -g snarkjs
