#!/bin/sh
set -eu

lock=release/first-release.lock
count=0
seen=" "

while IFS="	" read -r atom source sha256 sha512; do
  case "$atom" in
    ""|'#'*) continue ;;
  esac

  count=$((count + 1))
  case "$seen" in
    *" $atom "*) echo "duplicate release root: $atom" >&2; exit 1 ;;
  esac
  seen="$seen$atom "

  package=${atom%%.*}
  opam_file="packages/$package/$atom/opam"
  if [ ! -f "$opam_file" ]; then
    echo "missing repository entry: $opam_file" >&2
    exit 1
  fi

  case "$source" in
    https://github.com/reuna-labs/*/archive/refs/tags/*.tar.gz) ;;
    *) echo "non-Reuna or mutable source for $atom: $source" >&2; exit 1 ;;
  esac

  if ! grep -Fq "src: \"$source\"" "$opam_file"; then
    echo "source mismatch for $atom" >&2
    exit 1
  fi
  if ! grep -Fq "\"sha256=$sha256\"" "$opam_file"; then
    echo "SHA-256 mismatch for $atom" >&2
    exit 1
  fi
  if ! grep -Fq "\"sha512=$sha512\"" "$opam_file"; then
    echo "SHA-512 mismatch for $atom" >&2
    exit 1
  fi
done < "$lock"

if [ "$count" -ne 13 ]; then
  echo "expected 13 first-release roots, found $count" >&2
  exit 1
fi

echo "release lock: $count roots verified"
