#!/usr/bin/env bash

docker-compose down --rmi all -v --remove-orphans
docker-compose up --build -d
cd ..
if [ ! -d "build" ]; then
	mkdir build
fi
cd build || exit
cmake -DCMAKE_BUILD_TYPE=Debug -DPACKAGE_TESTS=On .. ; make -j"$(nproc)"
./tests/unit/canary_ut --reporter compact --success
cd  ..
cd tests || exit
docker-compose down --rmi all -v --remove-orphans
