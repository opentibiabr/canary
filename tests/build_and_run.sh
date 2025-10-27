#!/usr/bin/env bash

# Clean up existing containers, images and volumes and start over
docker-compose down --rmi all -v --remove-orphans
docker-compose up --build -d

# Check if the build directory exists, if it doesn't exist it creates it
cd ..
if [ ! -d "build" ]; then
	mkdir build
fi
cd build || exit

# Configure the build using vcpkg and compile the project with 6 threads
cmake -DCMAKE_TOOLCHAIN_FILE=~/vcpkg/scripts/buildsystems/vcpkg.cmake -DCMAKE_BUILD_TYPE=Debug -DPACKAGE_TESTS=On .. ; make -j"$(nproc)"

# Run tests after compilation
./tests/unit/canary_ut --reporter compact --success
./tests/integration/canary_it --reporter compact --success

# Go back to the tests folder and clean the Docker environment again
cd ../tests || exit
docker-compose down --rmi all -v --remove-orphans
