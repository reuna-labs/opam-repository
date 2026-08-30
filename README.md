# Reuna Labs opam repository

This repository publishes the alpha OCaml Web3 package train without making
upstream acceptance a release dependency.

The packages are built from immutable GitHub release tags and every source
archive is SHA-256 and SHA-512 verified. Aptos and Sui are outside the first
release. Tezos is planned after v1 and is intentionally not packaged or
assessed here.

## Install

```sh
opam repository add reuna https://github.com/reuna-labs/opam-repository.git
opam update
```

Then install only the protocol packages you need, for example:

```sh
opam install solana cosmos tron
```

These are alpha packages. They are not audited, and live signing should remain
policy-gated with low-value testnet accounts.

## Maintenance

`tools/import-release.sh` imports every opam package in one tagged repository,
removes source-only pin metadata, and attaches archive checksums. Run
`tools/check.sh` before publishing changes.

