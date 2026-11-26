ARG ALPINE_IMAGE=docker.m.daocloud.io/alpine:3.24
FROM ${ALPINE_IMAGE}

ARG APK_MIRROR=https://mirrors.tuna.tsinghua.edu.cn/alpine
RUN printf '%s/v3.24/main\n%s/v3.24/community\n' "$APK_MIRROR" "$APK_MIRROR" > /etc/apk/repositories \
    && apk add --no-cache ca-certificates clang llvm lld cmake samurai python3 \
        e2fsprogs e2fsprogs-extra perl-utils curl zip binutils xz tar

WORKDIR /work
COPY build.sh /usr/local/bin/inkwell-build
ENTRYPOINT ["/bin/sh", "/usr/local/bin/inkwell-build"]
