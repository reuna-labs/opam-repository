# OCaml Web3 defensive review plan

Status: active alpha hardening program. This is a review scope, not an audit
claim.

## Authorized targets

- Reuna-owned first-release source repositories and tagged archives;
- the Reuna opam overlay, importer, lock and CI;
- hermetic parsers, codecs, transaction builders, signing boundaries, state
  machines and policy explainers;
- manually approved, low-value testnet workflows already configured by Reuna.

Third-party RPC providers and upstream repositories are dependencies and
oracles, not penetration-test targets.

## Priority review order

1. Shared protobuf/CBOR/RLP/Base58/Bech32 parsers and allocation bounds.
2. Digest/hash selection, canonical byte retention and signature construction.
3. Byte-derived intent, opaque/unknown handling and policy fail-closed rules.
4. Replay/freshness, submission ambiguity, finality and restart state machines.
5. TLS hostname/SNI/trust-root selection and transport size/time bounds.
6. Package provenance, immutable tags, checksums and fork maintenance.

## Required evidence before production-value use

- sustained sanitizer/fuzz campaigns for every untrusted parser, with corpus
  retention and reproducible crash triage;
- independent review of each signing and policy boundary;
- explicit threat model and security policy in every value-handling repository;
- a clean locked-package install on the minimum, current and Reuna OCaml 5.5
  compilers;
- no unresolved critical/high findings, or a written risk acceptance naming
  scope, owner, expiry and compensating controls.

Live testnet success is useful conformance evidence and is never a substitute
for these gates.
