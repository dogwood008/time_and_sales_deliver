# syntax=docker/dockerfile:1.2

FROM rust:1.55-bullseye

RUN mkdir /app
WORKDIR /app

COPY Cargo.toml /app/Cargo.toml
COPY Cargo.lock /app/Cargo.lock
COPY src /app/src

# https://stackoverflow.com/a/60590697
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/home/root/app/target \
  cargo install --path .

# 後でマルチステージビルドとして使い、生成物だけ残しこのステージは破棄する
RUN cargo install diesel_cli --no-default-features --features postgres