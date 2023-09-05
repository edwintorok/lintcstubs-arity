#!/bin/sh
set -eux
DIR="$(opam var prefix)/lib/ocaml-src"
# the testsuite contains many toplevel tests where parsing would fail
if [ -d "${DIR}" ]; then
  grep --files-with-matches --exclude-dir 'testsuite/' --include '*.ml' -r 'external ' "${DIR}" | xargs "${1}"
fi