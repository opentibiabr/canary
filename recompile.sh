#!/bin/bash

set -euo pipefail

# Variáveis
VCPKG_PATH=${1:-"$HOME"}
VCPKG_PATH=$VCPKG_PATH/vcpkg/scripts/buildsystems/vcpkg.cmake
BUILD_TYPE=${2:-"linux-release"}
ARCHITECTURE=$(uname -m)
ARCHITECTUREVALUE=0

# Function to print information messages
info() {
	echo -e "\033[1;34m[INFO]\033[0m $1"
}

# Function to check if a command is available
check_command() {
	if ! command -v "$1" >/dev/null; then
		echo "The command '$1' is not available. Please install it and try again."
		exit 1
	fi
}

check_architecture() {
	if [[ $ARCHITECTURE == "aarch64"* ]]; then
		info "its architecture is ARM"
		ARCHITECTUREVALUE=1
	else
		info "its architecture is ARM $ARCHITECTURE"
	fi
}

# Function to configure Canary
setup_canary() {
	if [ -d "build" ]; then
		cd build
	else
		mkdir -p build && cd build
		info "Canary has already been configured, skipping this step..."
	fi
}

# Function to build Canary
build_canary() {
	info "Configuring Canary..."
	if [[ $ARCHITECTUREVALUE == 1 ]]; then
		export VCPKG_FORCE_SYSTEM_BINARIES=1
	fi
	cmake -DCMAKE_TOOLCHAIN_FILE="$VCPKG_PATH" .. --preset "$BUILD_TYPE" >cmake_log.txt 2>&1 || {
		cat cmake_log.txt
		return 1
	}

	info "Starting the build process..."

	local total_steps=0
	local progress=0
	local build_status=0

	global_beats=0
	local temp_file="temp_global_beats.txt"
	echo "0" >$temp_file

	cmake --build "$BUILD_TYPE" 2>&1 > >(while IFS= read -r line; do
		echo "$line" >>build_log.txt
		if [[ $line =~ ^\[([0-9]+)/([0-9]+)\].* ]]; then
			current_step=${BASH_REMATCH[1]}
			total_steps=${BASH_REMATCH[2]}
			progress=$((current_step * 100 / total_steps))
			printf "\r\033[1;32m[INFO]\033[0m Progress build: [%3d%%]" $progress
			echo "1" >$temp_file
		fi
	done) || build_status=1

	global_beats=$(cat $temp_file)
	rm $temp_file

	if [[ $build_status -eq 0 ]]; then
		if [[ $global_beats == 1 ]]; then
			echo
		fi
		return 0
	else
		echo
		cat build_log.txt
		return 1
	fi
}

# Function to move the generated executable
move_executable() {
	local executable_name="canary"
	cd ..
	if [ -e "$executable_name" ]; then
		info "Saving old build"
		mv ./"$executable_name" ./"$executable_name".old
	fi
	info "Moving the generated executable to the canary folder directory..."
	cp ./build/linux-release/bin/"$executable_name" ./"$executable_name"
	info "Build completed successfully!"
}

# Main function
main() {
	check_command "cmake"
	check_architecture
	setup_canary

	if build_canary; then
		move_executable
	else
		echo -e "\033[31m[ERROR]\033[0m Build failed..."
		exit 1
	fi
}

main
