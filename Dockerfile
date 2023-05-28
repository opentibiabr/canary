FROM ubuntu:22.04 AS builder

WORKDIR /opt

RUN apt-get update && apt-get install -y --no-install-recommends cmake git \
	unzip build-essential ca-certificates curl zip unzip tar \
	pkg-config ninja-build autoconf automake libtool \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/Microsoft/vcpkg.git \
	&& cd vcpkg \
	&& ./bootstrap-vcpkg.sh

WORKDIR /build

COPY . .

ENV VCPKG_ROOT=/opt/vcpkg
RUN cmake --preset release
RUN cmake --build --preset release

FROM ubuntu:22.04

WORKDIR /srv/canary

ENTRYPOINT ["/srv/canary/canary"]

VOLUME /srv/canary/logs

COPY --from=builder build/release/bin/canary ./canary
COPY data ./data/
COPY data-canary ./data-canary/
COPY data-otservbr-global ./data-otservbr-global/
COPY key.pem config.lua start.sh ./