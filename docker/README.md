# Docker build

From this repository, with Docker running:

```bash
./build-docker.sh
```

This builds an Alpine 3.24 toolchain image from `docker/Dockerfile`, then
cross-compiles the Kindle system in a container. It uses
`docker.m.daocloud.io/alpine:3.24` for the base image and Tsinghua's Alpine
mirror for packages and the ARMv7 sysroot. No ARM emulation or privileged
container is needed. The source directory is mounted into the container;
`downloads/` caches downloads and `out/alpine.img` is the resulting image.
Files are written as your host user. The default time zone is `Asia/Shanghai`
and SSH keys are excluded. The Docker build defaults to **no AI or games**:
Quill/llama.cpp, Doom, Minecraft, TriKing and Chess are neither compiled nor
included in the image or launcher. llama.cpp, Doom's WAD and language models
are not downloaded. Reading, browser, terminal, notes, sketch, dashboard and
system apps remain available.

To also create an installable zip containing `linux/` and `documents/`:

```bash
./build-docker.sh 1.1.0
# dist/Inkwell-1.1.0.zip and dist/SHA256SUMS
```

The release script always uses UTC and excludes SSH keys. For a local image,
`TZ_NAME=UTC ./build-docker.sh` changes the time zone and
`NO_KEYS= ./build-docker.sh` includes existing keys from `keys/`.

Download sources and build settings can be overridden when needed:

```bash
ALPINE_IMAGE=alpine:3.24 APK_MIRROR=https://dl-cdn.alpinelinux.org/alpine \
  ALPINE_MIRROR=https://dl-cdn.alpinelinux.org/alpine ./build-docker.sh
```

`APK_MIRROR` configures the container's package source; `ALPINE_MIRROR`
configures the target rootfs and sysroot source. Both are base URLs without
`/v3.24`. With optional features enabled, GitHub and Debian supply llama.cpp
and Doom, and Hugging Face supplies models. Downloads
retain the upstream checksum checks. Rerun the same command after a network
failure to reuse completed downloads and the toolchain image.
To enable optional features:

```bash
BUILD_LLM=1 ./build-docker.sh       # Quill and llama.cpp, quick model only
BUILD_GAMES=1 ./build-docker.sh     # Doom, Minecraft, TriKing and Chess
BUILD_LLM=1 BUILD_GAMES=1 ./build-docker.sh 1.1.0  # full release
```

`QUICK_ONLY=0` fetches all three models when AI is enabled.
Direct host builds default to all features. Set `BUILD_LLM=0 BUILD_GAMES=0`
for both `tools/fetch.sh` and `./build-rootfs.sh` to omit AI and games.
`CMAKE_BUILD_PARALLEL_LEVEL` defaults to `2`; raise it for faster compilation
if memory permits. `SIZE` sets the rootfs image size (default `1G`).
