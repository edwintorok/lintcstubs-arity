#!/bin/sh
set -eux
DIR="$(opam var prefix)/lib"
if [ -d "${DIR}" ]; then
  find "${DIR}" -name '*.cmt' | xargs "${1}"
fi