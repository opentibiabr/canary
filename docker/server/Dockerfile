# Stage 1: Download all dependencies
FROM ubuntu:20.04 AS dependencies

RUN apt-get update && apt-get install -y --no-install-recommends cmake

RUN apt-get update && apt-get install -y --no-install-recommends git

RUN apt-get install -y --no-install-recommends \
	build-essential ca-certificates curl zip unzip tar pkg-config

RUN apt-get install -y --no-install-recommends libluajit-5.1-dev unzip

WORKDIR /opt
RUN git clone https://github.com/microsoft/vcpkg --depth=1
RUN ./vcpkg/bootstrap-vcpkg.sh

WORKDIR /opt/vcpkg
COPY vcpkg.json /opt/vcpkg/
RUN /opt/vcpkg/vcpkg --feature-flags=binarycaching,manifests,versions install

# Stage 2: create build
FROM dependencies AS build

COPY cmake /srv/cmake
COPY CMakeLists.txt vcpkg.json /srv/
COPY src /srv/src

WORKDIR /srv/build

RUN cmake -DCMAKE_TOOLCHAIN_FILE=/opt/vcpkg/scripts/buildsystems/vcpkg.cmake .. && make -j`nproc`

# Stage 3: load data and execute
FROM ubuntu:20.04

COPY --from=build /srv/build/bin/canary /bin/canary
COPY LICENSE *.sql key.pem /canary/
COPY data /canary/data
COPY config.lua.dist /canary/config.lua

WORKDIR /canary

RUN apt-get update && apt-get install -y --no-install-recommends libluajit-5.1-dev mariadb-client

COPY docker/server/start.sh start.sh

ENTRYPOINT ["/canary/start.sh"]
