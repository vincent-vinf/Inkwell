#!/bin/sh
# Build on the host's architecture; clang cross-compiles for the Kindle.
# AI and games are opt-in: BUILD_LLM=1 BUILD_GAMES=1 ./build-docker.sh.
set -eu
if [ "$#" -gt 1 ]; then
    echo "Usage: $0 [release-version]" >&2
    exit 2
fi
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
IMAGE=${BUILDER_IMAGE:-inkwell-builder:alpine3.24}
docker build \
    --build-arg "ALPINE_IMAGE=${ALPINE_IMAGE:-docker.m.daocloud.io/alpine:3.24}" \
    --build-arg "APK_MIRROR=${APK_MIRROR:-https://mirrors.tuna.tsinghua.edu.cn/alpine}" \
    -t "$IMAGE" -f "$ROOT/docker/Dockerfile" "$ROOT/docker"
docker run --rm --user "$(id -u):$(id -g)" \
    --mount "type=bind,src=$ROOT,dst=/work" \
    -e "ALPINE_MIRROR=${ALPINE_MIRROR:-https://mirrors.tuna.tsinghua.edu.cn/alpine}" \
    -e "QUICK_ONLY=${QUICK_ONLY:-1}" \
    -e "BUILD_LLM=${BUILD_LLM:-0}" \
    -e "BUILD_GAMES=${BUILD_GAMES:-0}" \
    -e "TZ_NAME=${TZ_NAME:-Asia/Shanghai}" \
    -e "SIZE=${SIZE:-1G}" \
    -e "NO_KEYS=${NO_KEYS-1}" \
    -e "CMAKE_BUILD_PARALLEL_LEVEL=${CMAKE_BUILD_PARALLEL_LEVEL:-2}" \
    "$IMAGE" "$@"
