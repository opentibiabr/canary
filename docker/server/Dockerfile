# Stage 1: Download all dependencies
FROM ubuntu:20.04 AS dependencies

# Stage 1.1: Setup kitware repository
## According to: https://apt.kitware.com/
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends gpg wget ca-certificates && \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null && \
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install kitware-archive-keyring && \
    rm /usr/share/keyrings/kitware-archive-keyring.gpg

# Stage 1.2: Install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends cmake git build-essential curl zip unzip tar pkg-config ninja-build libluajit-5.1-dev

WORKDIR /opt
RUN git clone https://github.com/microsoft/vcpkg --depth=1 && \
    ./vcpkg/bootstrap-vcpkg.sh

WORKDIR /opt/vcpkg
COPY vcpkg.json /opt/vcpkg/
RUN VCPKG_FORCE_SYSTEM_BINARIES=1 /opt/vcpkg/vcpkg --feature-flags=binarycaching,manifests,versions install

# Stage 2: create build
FROM dependencies AS build

COPY cmake /srv/cmake
COPY CMakeLists.txt vcpkg.json /srv/
COPY src /srv/src

WORKDIR /srv/build

RUN VCPKG_FORCE_SYSTEM_BINARIES=1 cmake -DCMAKE_TOOLCHAIN_FILE=/opt/vcpkg/scripts/buildsystems/vcpkg.cmake .. && make -j`nproc`

# Stage 3: load data and execute
FROM ubuntu:20.04

COPY --from=build /srv/build/bin/canary /bin/canary
COPY LICENSE *.sql key.pem /canary/
COPY data /canary/data
COPY config.lua.dist /canary/config.lua

WORKDIR /canary

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends libluajit-5.1-dev mariadb-client

COPY docker/server/start.sh start.sh

ENTRYPOINT ["/canary/start.sh"]
