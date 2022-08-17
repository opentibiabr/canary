# Stage 1: Download all dependencies
FROM ubuntu:22.04 AS dependencies

RUN apt-get update && apt-get upgrade -y && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cmake git \
	unzip build-essential ca-certificates curl zip unzip tar \
	pkg-config ninja-build autoconf automake libtool \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt
RUN git clone https://github.com/microsoft/vcpkg --depth=1 && \
    ./vcpkg/bootstrap-vcpkg.sh

WORKDIR /opt/vcpkg
COPY vcpkg.json /opt/vcpkg/
RUN VCPKG_FORCE_SYSTEM_BINARIES=1 /opt/vcpkg/vcpkg --feature-flags=binarycaching,manifests,versions install

# Stage 2: create build
FROM dependencies AS build

COPY . /srv/
WORKDIR /srv

RUN export VCPKG_ROOT=/opt/vcpkg/ && VCPKG_FORCE_SYSTEM_BINARIES=1 cmake --preset linux-release && cmake --build --preset linux-release

# Stage 3: load data and execute
FROM ubuntu:22.04

COPY --from=build /srv/build/linux-release/bin/canary /bin/canary
COPY LICENSE *.sql key.pem /canary/
COPY data /canary/data
COPY config.lua.dist /canary/config.lua

WORKDIR /canary

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	mariadb-client \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY docker/server/start.sh start.sh

ENTRYPOINT ["/canary/start.sh"]
