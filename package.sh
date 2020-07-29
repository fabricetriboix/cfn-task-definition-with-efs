#!/bin/bash

set -eu -o pipefail

tmp=$(realpath "$0")
dir=$(dirname "$tmp")
cd "$dir"

rm -f task_definition.zip
tmpdir=$(mktemp -d ./pkg-XXXXXX)
pip3 install --system --target "$tmpdir" -r requirements.txt
cd "$tmpdir"
zip -r9 ../task_definition.zip .
cd ..
rm -rf "$tmpdir"
zip -g task_definition.zip task_definition.py
