#!/usr/bin/env bash

docker-compose down --rmi all -v --remove-orphans
docker-compose up --build -d
cd ..
mkdir build
cd build
cmake -DUT=1 -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_TOOLCHAIN_FILE=/opt/workspace/vcpkg/scripts/buildsystems/vcpkg.cmake .. ; make -j`nproc`
./tests/canary_unittest  --reporter compact --success -d yes
cd  ..
cd tests
docker-compose down --rmi all -v --remove-orphans
