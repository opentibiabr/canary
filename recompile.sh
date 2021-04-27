#!/bin/bash

if [ -d "build" ]
then
	echo "Directory 'build' already exists, moving to it"
	cd build
	echo "Clean build directory"
	rm -rf *
	echo "Configuring"
	cmake ..
else
	mkdir "build" && cd build
	cmake ..
fi

make -j$(nproc) || exit 1
if [ $? -eq 1 ]
then
	echo "Compilation failed!"
else
	echo "Compilation successful!"
	cd ..
	if [ -f "otbr" ]; then
		echo "Saving old build"
		mv ./otbr ./otbr.old
	fi
	cp ./build/otbr ./otbr
fi
