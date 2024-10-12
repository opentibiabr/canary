#!/usr/bin/env bash

# Install necessary dependencies
echo "Installing necessary dependencies..."
sudo apt-get update && sudo apt-get install -y build-essential cmake ninja-build curl zip unzip docker-compose

# Clean up existing containers, images, and volumes and start over
docker-compose down --rmi all -v --remove-orphans
docker-compose up --build -d

# Wait until MySQL X Protocol (port 33060) is ready
echo "Waiting for database to initialize..."
until docker exec otdb-test mysqlsh --mysqlx -h127.0.0.1 -P33060 -uotserver -potserver --execute "select 1" > /dev/null 2>&1; do
    sleep 3
done
echo "Database initialized."

# Define the absolute path for vcpkg
VCPKG_ROOT="$HOME/vcpkg"

# Install vcpkg if it doesn't exist
if [ ! -d "$VCPKG_ROOT" ]; then
    echo "Installing vcpkg..."
    git clone https://github.com/microsoft/vcpkg.git "$VCPKG_ROOT"
    cd "$VCPKG_ROOT" || exit
    ./bootstrap-vcpkg.sh
    cd - || exit
fi

# Check if the build directory exists, if it doesn't exist, create it
cd .. || exit
if [ ! -d "build" ]; then
    mkdir build
fi
cd build || exit

# Install project dependencies via vcpkg
echo "Installing project dependencies via vcpkg..."
$VCPKG_ROOT/vcpkg install

# Configure the build using vcpkg and compile the project with multiple threads
echo "Configuring and building the project..."
cmake -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake -DCMAKE_BUILD_TYPE=Debug -DPACKAGE_TESTS=On .. 
make -j"$(nproc)"

# Run unit tests after compilation
echo "Running unit tests..."
./tests/unit/canary_ut --reporter compact --success

# Go back to the tests folder and clean the Docker environment again
cd ../tests || exit
docker-compose down --rmi all -v --remove-orphans
