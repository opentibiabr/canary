#!/usr/bin/env bash

docker-compose down --rmi all -v --remove-orphans
docker-compose up --build -d
cd ..
mkdir build
cd build
cmake -DPACKAGE_TESTS=On .. ; make -j`nproc`
./tests/otbr_unittest  --reporter compact --success -d yes
cd  ..
cd tests
docker-compose down --rmi all -v --remove-orphans
