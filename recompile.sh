#!/bin/bash

if [ -d "build" ]
then
	echo "Directory 'build' already exists, moving to it"
	cd build
	echo "Clean build directory"
	rm -rf *
	echo "Configuring"
	cmake -DCMAKE_TOOLCHAIN_FILE=../../vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release
else
	mkdir "build" && cd build
	cmake -DCMAKE_TOOLCHAIN_FILE=../../vcpkg/scripts/buildsystems/vcpkg.cmake .. --preset linux-release
fi

cmake --build linux-release || exit 1
if [ $? -eq 1 ]
then
	echo "Compilation failed!"
else
	echo "Compilation successful!"
	cd ..
	if [ -f "canary" ]; then
		echo "Saving old build"
		mv ./canary ./canary.old
	fi
	cp ./build/linux-release/bin/canary ./canary
fi
