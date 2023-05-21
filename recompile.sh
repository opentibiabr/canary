#!/bin/bash

cd ~/vcpkg && export VCPKG_FORCE_SYSTEM_BINARIES=1 && cd ~/canary

if [ -d "build" ]; then
	echo "Directory 'build' already exists, moving to it"
	cd build
	export VCPKG_FORCE_SYSTEM_BINARIES=1
	echo "Clean build directory"
	rm -rf *
	echo "Configuring"
	# for root directory
	cmake -DCMAKE_TOOLCHAIN_FILE=../../vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release
	# for home directory
	# cmake -DCMAKE_TOOLCHAIN_FILE=~/vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release
else
	mkdir "build" && cd build
	export VCPKG_FORCE_SYSTEM_BINARIES=1
	# for root directory
	cmake -DCMAKE_TOOLCHAIN_FILE=../../vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release	
	# for home directory
	# cmake -DCMAKE_TOOLCHAIN_FILE=~/vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release
fi

cmake --build linux-release || exit 1
if [ $? -eq 1 ]; then
	echo "Compilation failed!"
else
	echo "Compilation successful!"
	cd ~/canary
	if [ -f "canary" ]; then
		echo "Saving old build"
		mv ./canary ./canary.old
	fi
	cp ./build/linux-release/bin/canary ./canary
fi
