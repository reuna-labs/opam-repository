# First-release lock

`first-release.lock` is the source of truth for the first OCaml Web3 package
train. Each tab-separated row records an exact root package, immutable public
source archive, SHA-256 and SHA-512. Aptos, Sui and Tezos are deliberately
absent.

`tools/check-release.sh` proves that every row matches the corresponding opam
repository entry and that the root list is unique. The install matrix reads the
same lock directly, so CI cannot silently drift from this manifest.

Changing a row requires a new immutable source tag and regenerated archive
checksums. Never edit a checksum to accommodate a changed archive at an
existing tag.
