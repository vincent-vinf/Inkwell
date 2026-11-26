#!/bin/sh
set -eu
cd /work
tools/fetch.sh
if [ "$#" -eq 0 ]; then
    exec ./build-rootfs.sh
fi
exec tools/release.sh "$1"
