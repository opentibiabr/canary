# syntax=docker/dockerfile:1.7
#
# Builds a Canary image with the optional "multichannel" vcpkg feature
# (Redis client) enabled, from the current source checkout. This is a
# multichannel-specific variant of ../Dockerfile.dev, which does not request
# any optional vcpkg features. See docker/multichannel/README.md.
#
# NOT build-tested in the sandbox this PR was authored in (no working Docker
# daemon available there - see docs/multichannel/TEST_PLAN.md). Review
# against ../Dockerfile.dev before relying on it in production.

FROM ubuntu:24.04 AS dependencies

ARG DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}
ENV TZ=Etc/UTC

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
	--mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
	apt-get update && apt-get install -y --no-install-recommends cmake git \
	unzip build-essential ca-certificates curl zip unzip tar \
	pkg-config ninja-build autoconf automake libtool glibc-tools \
	python3 mono-complete tzdata \
	&& ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime \
	&& echo "${TZ}" > /etc/timezone \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt
COPY vcpkg.json /opt
RUN vcpkgCommitId=$(grep '.builtin-baseline' vcpkg.json | awk -F: '{print $2}' | tr -d '," ' | tr -d '\r\n') \
    && git clone https://github.com/microsoft/vcpkg.git \
    && cd vcpkg \
    && git fetch origin \
    && git checkout "$vcpkgCommitId" \
    && ./bootstrap-vcpkg.sh

WORKDIR /opt/vcpkg_manifest
COPY vcpkg.json /opt/vcpkg_manifest/

# The only difference from ../Dockerfile.dev: request the "multichannel"
# vcpkg feature (hiredis) in addition to the default dependency set.
RUN /opt/vcpkg/vcpkg install \
	--x-manifest-root=/opt/vcpkg_manifest \
	--x-install-root=/opt/vcpkg_installed \
	--x-feature=multichannel

FROM dependencies AS build
WORKDIR /srv/build
COPY src ./src
COPY cmake ./cmake
COPY recompile.sh CMakeLists.txt CMakePresets.json vcpkg.json ./
COPY --from=dependencies /opt/vcpkg_installed ./vcpkg_installed

# The only difference from ../Dockerfile.dev: turn on FEATURE_MULTICHANNEL_REDIS.
RUN ./recompile.sh "/opt" linux-release \
	-DVCPKG_MANIFEST_INSTALL=OFF \
	-DVCPKG_INSTALLED_DIR=/srv/build/vcpkg_installed \
	-DFEATURE_MULTICHANNEL_REDIS=ON

FROM ubuntu:24.04 AS prod
COPY --from=build /srv/build/build/linux-release/bin/canary /bin/canary
WORKDIR /srv/canary
ENTRYPOINT ["/srv/canary/start.sh", "canary"]
