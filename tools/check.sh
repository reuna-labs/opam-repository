#!/bin/sh
set -eu

opam admin check --normalize
git diff --check

