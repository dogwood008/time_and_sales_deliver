FROM rust:1.55-bullseye

RUN mkdir /app
WORKDIR /app

COPY Cargo.toml /app/Cargo.toml
COPY Cargo.lock /app/Cargo.lock
COPY src /app/src

RUN cargo install --path .
