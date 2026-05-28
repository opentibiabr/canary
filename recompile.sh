#!/bin/bash

set -euo pipefail

# ============================================================================
# Configuration
# ============================================================================

VCPKG_PATH=${1:-"$HOME"}
VCPKG_PATH="$VCPKG_PATH/vcpkg/scripts/buildsystems/vcpkg.cmake"
BUILD_TYPE=${2:-"linux-release"}
ARCHITECTURE=$(uname -m)
EXTRA_CMAKE_ARGS=("${@:3}")
IS_ARM64=0

# ============================================================================
# Logging helpers
# ============================================================================

info() {
	local message_info=$1
	echo -e "\033[1;34m[INFO]\033[0m $message_info"
}

success() {
	local message_success=$1
	echo -e "\033[1;32m[OK]\033[0m $message_success"
}

error() {
	local message_error=$1
	echo -e "\033[1;31m[ERROR]\033[0m $message_error" >&2
}

# ============================================================================
# Environment checks
# ============================================================================

check_command() {
	local command_name=$1
	if ! command -v "$command_name" >/dev/null; then
		error "The command '$command_name' is not available. Please install it and try again."
		exit 1
	fi
}

check_architecture() {
	if [[ $ARCHITECTURE == "aarch64"* ]]; then
		info "Architecture detected: $ARCHITECTURE (ARM)"
		IS_ARM64=1
	else
		info "Architecture detected: $ARCHITECTURE"
	fi
}

check_vcpkg() {
	if [[ ! -f "$VCPKG_PATH" ]]; then
		error "vcpkg toolchain not found at: $VCPKG_PATH"
		error "Pass the vcpkg parent directory as the first argument, or install vcpkg in \$HOME."
		exit 1
	fi
}

# ============================================================================
# Generic progress runner
# Runs a command in background, tails its log, and parses progress lines.
# Args:
#   $1 = display label (e.g. "vcpkg", "Build")
#   $2 = log file path
#   $3 = regex pattern (with capture groups for current and total)
#   $4 = capture group index for "current" value
#   $5 = capture group index for "total" value
#   $6..$N = command and its arguments
# ============================================================================

run_with_progress() {
	local label=$1
	local log_file=$2
	local pattern=$3
	local current_idx=$4
	local total_idx=$5
	shift 5

	# Truncate previous log
	: >"$log_file"

	local progress_marker
	progress_marker=$(mktemp)
	echo "0" >"$progress_marker"

	# Launch command in background
	"$@" >"$log_file" 2>&1 &
	local cmd_pid=$!

	# Tail the log in parallel; auto-exits when cmd_pid dies
	(
		# Small wait so the log file definitely exists
		while [[ ! -s "$log_file" ]] && kill -0 "$cmd_pid" 2>/dev/null; do
			sleep 0.1
		done

		tail -f "$log_file" --pid="$cmd_pid" 2>/dev/null | while IFS= read -r line; do
			if [[ $line =~ $pattern ]]; then
				local current=${BASH_REMATCH[$current_idx]}
				local total=${BASH_REMATCH[$total_idx]}
				# Guard against non-numeric matches (defensive: malformed regex)
				if ! [[ $current =~ ^[0-9]+$ && $total =~ ^[0-9]+$ && $total -gt 0 ]]; then
					continue
				fi
				local progress=$((current * 100 / total))
				printf "\r\033[1;32m[INFO]\033[0m %s progress: [%3d%%] (%d/%d)   " \
					"$label" "$progress" "$current" "$total"
				echo "1" >"$progress_marker"
			fi
		done
	)

	local cmd_status=0
	wait "$cmd_pid" || cmd_status=1

	local had_progress
	had_progress=$(cat "$progress_marker")
	rm -f "$progress_marker"

	# Newline only if we actually printed a progress bar
	[[ $had_progress == 1 ]] && echo

	return $cmd_status
}

# ============================================================================
# Build steps
# ============================================================================

setup_canary() {
	if [ -d "build" ]; then
		info "Existing build directory found, reusing it."
		cd build
	else
		info "Creating build directory..."
		mkdir -p build && cd build
	fi
}

move_executable() {
	local executable_name="canary"
	if [[ -e "$executable_name" ]]; then
		info "Saving previous build as ${executable_name}.old"
		mv "$executable_name" "${executable_name}.old"
	fi
}

configure_canary() {
	info "Configuring Canary (this includes vcpkg dependency install)..."

	if [[ $IS_ARM64 == 1 ]]; then
		export VCPKG_FORCE_SYSTEM_BINARIES=1
	fi

	# vcpkg emits lines like:
	#   "Installing 1/16 openssl:arm64-linux@3.6.2..."
	#   "Building 3/16 boost-asio:arm64-linux..."
	#   "Restored 5/16 fmt:arm64-linux..."
	# Group 1: action (discarded), Group 2: current, Group 3: total
	local vcpkg_pattern='(Installing|Building|Restored)[[:space:]]+([0-9]+)/([0-9]+)'

	if ! run_with_progress "vcpkg" "cmake_log.txt" "$vcpkg_pattern" 2 3 \
		cmake -DCMAKE_TOOLCHAIN_FILE="$VCPKG_PATH" "${EXTRA_CMAKE_ARGS[@]}" .. \
		--preset "$BUILD_TYPE"; then
		error "CMake configuration failed. Full log:"
		cat cmake_log.txt
		return 1
	fi

	success "Configuration complete."
}

compile_canary() {
	info "Starting the build process..."

	# CMake/Ninja build emits lines like "[42/300] Building CXX object..."
	# Group 1: current, Group 2: total
	local build_pattern='^\[([0-9]+)/([0-9]+)\]'

	if ! run_with_progress "Build" "build_log.txt" "$build_pattern" 1 2 \
		cmake --build "$BUILD_TYPE"; then
		error "Build failed. Full log:"
		cat build_log.txt
		return 1
	fi

	success "Build completed successfully!"
}

# ============================================================================
# Main
# ============================================================================

main() {
	check_command "cmake"
	check_command "tail"
	check_vcpkg
	check_architecture
	move_executable
	setup_canary

	configure_canary || exit 1
	compile_canary || exit 1
}

main