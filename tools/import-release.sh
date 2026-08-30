#!/bin/sh
set -eu

if [ "$#" -ne 4 ]; then
  echo "usage: $0 OWNER/REPOSITORY TAG OPAM_VERSION PACKAGE_GLOB" >&2
  exit 2
fi

repository=$1
tag=$2
version=$3
package_glob=$4
archive_url="https://github.com/$repository/archive/refs/tags/$tag.tar.gz"
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT HUP INT TERM

archive="$work_dir/source.tar.gz"
curl --fail --location --retry 5 --output "$archive" "$archive_url"
sha256=$(shasum -a 256 "$archive" | cut -d ' ' -f 1)
sha512=$(shasum -a 512 "$archive" | cut -d ' ' -f 1)
tar -xzf "$archive" -C "$work_dir"
source_dir=$(find "$work_dir" -mindepth 1 -maxdepth 1 -type d | head -n 1)

found=false
for source_opam in "$source_dir"/$package_glob; do
  [ -f "$source_opam" ] || continue
  found=true
  package=$(basename "$source_opam" .opam)
  destination="packages/$package/$package.$version"
  mkdir -p "$destination"

  # Repository versions come from the directory name. pin-depends is useful
  # while developing a source checkout but is neither needed nor accepted in
  # published repository metadata because every sibling is imported here.
  awk '
    /^version:[[:space:]]/ { next }
    # Multi-package dune projects often leave tests unassigned to an opam
    # package. Running the generated global @runtest alias while installing
    # one subpackage then requires siblings that are not installed yet. The
    # tagged repositories run their complete suites in CI; overlay installs
    # build the package-scoped @install target only.
    /^[[:space:]]*"@runtest"[[:space:]]*\{with-test\}[[:space:]]*$/ { next }
    /^pin-depends:[[:space:]]*\[/ { skipping = 1; next }
    skipping && /^\][[:space:]]*$/ { skipping = 0; next }
    skipping { next }
    { print }
  ' "$source_opam" > "$destination/opam"

  {
    echo
    echo 'url {'
    echo "  src: \"$archive_url\""
    echo '  checksum: ['
    echo "    \"sha256=$sha256\""
    echo "    \"sha512=$sha512\""
    echo '  ]'
    echo '}'
  } >> "$destination/opam"
done

if [ "$found" != true ]; then
  echo "no packages matched $package_glob in $repository@$tag" >&2
  exit 1
fi
