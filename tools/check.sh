#!/bin/sh
set -eu

find packages -name opam -type f -print | while IFS= read -r opam_file; do
  opam lint "$opam_file"
done
opam admin check --cycles
./tools/check-release.sh
git diff --check
