#!/bin/bash

set -euo pipefail

# Linux build and executable history. See docs/building/recompile.md.
# The running server is restarted only with --restart-service.

WORKTREE_ROOT=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
BUILD_TYPE=linux-release
BUILD_JOBS=${CMAKE_BUILD_PARALLEL_LEVEL:-2}
VCPKG_PARENT_DIRECTORY=""
EXTRA_CMAKE_ARGS=()
RESTART_SERVICE=0
EXECUTABLE_UPDATED=0
BACKUP_DIRECTORY="$WORKTREE_ROOT/backups/executables"
RETENTION_SECONDS=$((7 * 24 * 60 * 60))
PUBLISH_TEMP=""
LOG_TEMP=""
PRUNE_ALLOWED=1

info() { printf '[INFO] %s\n' "$*"; }
error() { printf '[ERROR] %s\n' "$*" >&2; }
die() { error "$*"; exit 1; }

usage() {
	cat <<'EOF'
Usage: ./recompile.sh [vcpkg-parent-directory] [configure-preset] [options]
                      [-- <cmake-options...>]

Linux/Bash entry point; Windows users can run help/tests through WSL.
Defaults: existing VCPKG_ROOT (otherwise $HOME/vcpkg), linux-release, 2 jobs.
An existing CMAKE_BUILD_PARALLEL_LEVEL overrides the default job count.

Options:
  -h, --help          Show this help without building or changing files.
  -j, --jobs N        Limit both the build and vcpkg to N parallel jobs.
  --restart-service   Restart canary.service only if a different executable
                      was installed successfully.

For compatibility, CMake -D options may also follow the two positional arguments
without '--'. Script options such as --jobs must come before the CMake options.

The existing build/<preset> tree, cached CMake and dependency caches are reused. The script
sets TOGGLE_BIN_FOLDER=ON to link in build/<preset>/bin, then atomically installs
canary (or canary-debug) at the repository root. CMake path/generator overrides
and TOGGLE_BIN_FOLDER=OFF are not supported by this entry point.
After configuration, a Ninja dry run checks for pending work. An up-to-date
build reuses its output; SHA-256 comparison decides whether to install/restart.

Exact ELF copies and metadata are kept in backups/executables for seven days
after their last use/backup. Identical binaries share one backup. Cleanup runs
after each successful invocation, including an up-to-date build; running
versions are retained. Failed builds leave the installed executable intact.

Examples:
  ./recompile.sh
  ./recompile.sh "$HOME" linux-debug --jobs 1
  ./recompile.sh -- -DOPTIONS_ENABLE_OPENMP=OFF
  ./recompile.sh --restart-service

Guide: docs/building/recompile.md
EOF
}

usage_error() { error "$*"; printf 'Use --help for usage.\n' >&2; exit 2; }

parse_arguments() {
	local positional_count=0 argument
	while (($#)); do
		argument=$1
		shift
		case "$argument" in
			-h | --help) usage; exit 0 ;;
			--restart-service) RESTART_SERVICE=1 ;;
			-j | --jobs)
				(($#)) || usage_error "$argument requires a positive job count."
				BUILD_JOBS=$1
				shift
				;;
			--jobs=*) BUILD_JOBS=${argument#*=} ;;
			-D*)
				((positional_count == 2)) || usage_error "Put CMake options after '--' or after both positional arguments."
				EXTRA_CMAKE_ARGS=("$argument" "$@")
				break
				;;
			--)
				(($#)) || usage_error "The '--' separator requires CMake options."
				EXTRA_CMAKE_ARGS=("$@")
				break
				;;
			-*) usage_error "Unknown option: $argument" ;;
			*)
				case "$positional_count" in
					0) VCPKG_PARENT_DIRECTORY=$argument ;;
					1) BUILD_TYPE=$argument ;;
					*) usage_error "Unexpected positional argument: $argument" ;;
				esac
				((positional_count += 1))
				;;
		esac
	done
	[[ $BUILD_JOBS =~ ^[1-9][0-9]{0,2}$ ]] || usage_error "Jobs must be a positive integer below 1000."
	[[ $BUILD_TYPE =~ ^linux-[a-zA-Z0-9_-]+$ ]] || usage_error "Select an existing Linux configure preset."
	for argument in "${EXTRA_CMAKE_ARGS[@]}"; do
		case "$argument" in
			-B* | -S* | -G* | --preset* | --build* | --install* | --workflow* | --toolchain*)
				usage_error "CMake path/generator overrides are not supported: $argument"
				;;
			*TOGGLE_BIN_FOLDER*=* | *CMAKE_TOOLCHAIN_FILE*=*)
				usage_error "This script manages TOGGLE_BIN_FOLDER and CMAKE_TOOLCHAIN_FILE; use the vcpkg positional argument."
				;;
			*) ;;
		esac
	done
}

check_command() {
	local command_name=$1
	command -v "$command_name" >/dev/null || die "Required command not found: $command_name"
}

cache_value() {
	local key=$1 line
	[[ -f "$BUILD_DIRECTORY/CMakeCache.txt" ]] || return 1
	while IFS= read -r line || [[ -n $line ]]; do
		line=${line%$'\r'}
		if [[ $line == "$key":*=* ]]; then
			printf '%s\n' "${line#*=}"
			return 0
		fi
	done <"$BUILD_DIRECTORY/CMakeCache.txt"
	return 1
}

digest() {
	local path=$1
	sha256sum -- "$path" | cut -d ' ' -f 1
}

is_executable_elf() {
	local path=$1
	LC_ALL=C readelf -h -- "$path" 2>/dev/null | grep -Eq '^[[:space:]]*Type:[[:space:]]+(EXEC|DYN)[[:space:]]'
}

# Backups have a dedicated, flat namespace. Never follow a directory symlink
# into another tree, and never recursively delete anything during retention.
check_directories() {
	local path
	for path in "$WORKTREE_ROOT/build" "$BUILD_DIRECTORY" "$BUILD_DIRECTORY/bin" \
		"$WORKTREE_ROOT/backups" "$BACKUP_DIRECTORY"; do
		[[ ! -L $path ]] || die "Refusing a symlinked build/backup directory: $path"
		[[ ! -e $path || -d $path ]] || die "Expected a directory: $path"
	done
	path="$BUILD_DIRECTORY/CMakeCache.txt"
	[[ ! -L $path ]] || die "Refusing a symlinked CMake cache: $path"
	[[ ! -e $path || -f $path ]] || die "Expected a regular CMake cache: $path"
}

archive_executable() {
	local source=$1 name=$2 checksum destination metadata saved_at build_id checkout temp
	[[ -f $source ]] || return 0
	checksum=$(digest "$source") || return 1
	[[ $checksum =~ ^[a-f0-9]{64}$ ]] || return 1
	destination="$BACKUP_DIRECTORY/$name-$checksum.bin"
	metadata="$BACKUP_DIRECTORY/$name-$checksum.meta"
	[[ ! -L $destination && ! -L $metadata ]] || { error "Refusing symlinked backup: $destination"; return 1; }
	if [[ -e $destination ]]; then
		[[ -f $destination && $(digest "$destination") == "$checksum" ]] || {
			error "Existing backup failed its SHA-256 check: $destination"
			return 1
		}
	else
		is_executable_elf "$source" || { error "Expected an ELF executable: $source"; return 1; }
		temp=$(mktemp "$BACKUP_DIRECTORY/.binary.XXXXXX") || return 1
		if ! cp --preserve=mode -- "$source" "$temp" || [[ $(digest "$temp") != "$checksum" ]]; then
			rm -f -- "$temp"
			error "Could not verify a complete backup of $source"
			return 1
		fi
		mv -fT -- "$temp" "$destination" || return 1
		info "Saved executable: $destination"
	fi
	# This is backup time, not the executable's old compilation mtime.
	saved_at=$(date -u +%s)
	build_id=$(LC_ALL=C readelf -n -- "$destination" | sed -n 's/.*Build ID: //p') || return 1
	checkout=$(git -C "$WORKTREE_ROOT" rev-parse HEAD 2>/dev/null) || checkout=unknown
	temp=$(mktemp "$BACKUP_DIRECTORY/.metadata.XXXXXX") || return 1
	if ! printf 'format=canary-executable-backup-v1\nname=%s\nsha256=%s\nbuild_id=%s\nsaved_at_epoch=%s\nsaved_at_utc=%s\ncheckout_at_backup=%s\n' \
		"$name" "$checksum" "${build_id:-unavailable}" "$saved_at" "$(date -u +%FT%TZ)" "$checkout" >"$temp"; then
		rm -f -- "$temp"
		return 1
	fi
	mv -fT -- "$temp" "$metadata"
}

archive_running_executables() {
	local before_build=${1:-0} process target name comm executable_fd stable_source stable_target
	for process in /proc/[0-9]*; do
		[[ -d $process ]] || continue
		if ! target=$(readlink -- "$process/exe" 2>/dev/null); then
			comm=$(cat "$process/comm" 2>/dev/null) || continue
			if [[ $comm == canary* ]]; then
				PRUNE_ALLOWED=0
			fi
			continue
		fi
		target=${target% (deleted)}
		case "$target" in
			"$WORKTREE_ROOT/canary-debug" | "$WORKTREE_ROOT/build/"*/bin/canary-debug | "$BACKUP_DIRECTORY/canary-debug-"*.bin) name=canary-debug ;;
			"$WORKTREE_ROOT/canary" | "$WORKTREE_ROOT/build/"*/bin/canary | "$BACKUP_DIRECTORY/canary-"*.bin) name=canary ;;
			*) continue ;;
		esac
		# Hold the executable inode open while hashing and copying it. The process
		# may exit after readlink, and Linux may immediately reuse its PID.
		if ! exec {executable_fd}<"$process/exe"; then
			[[ ! -e "$process/exe" ]] && continue
			error "Could not open the running executable for PID ${process##*/}."
			return 1
		fi
		stable_source="/proc/$$/fd/$executable_fd"
		if ! stable_target=$(readlink -- "$stable_source" 2>/dev/null); then
			exec {executable_fd}<&-
			error "Could not inspect the running executable for PID ${process##*/}."
			return 1
		fi
		stable_target=${stable_target% (deleted)}
		if [[ $stable_target != "$target" ]]; then
			exec {executable_fd}<&-
			continue
		fi
		if ! archive_executable "$stable_source" "$name"; then
			exec {executable_fd}<&-
			error "Could not preserve the running executable for PID ${process##*/}."
			return 1
		fi
		exec {executable_fd}<&-
		if ((before_build)) && [[ $stable_target == "$BUILD_DIRECTORY/bin/$name" ]]; then
			error "PID ${process##*/} runs from the compiler output. Build from a separate checkout or start the root executable first."
			return 1
		fi
	done
}

prune_backups() {
	local metadata filename name checksum saved_at now binary
	if ((PRUNE_ALLOWED == 0)); then
		info "Cleanup skipped: a Canary process could not be inspected."
		return 0
	fi
	now=$(date -u +%s)
	for metadata in "$BACKUP_DIRECTORY"/*.meta; do
		[[ -f $metadata && ! -L $metadata ]] || continue
		filename=${metadata##*/}
		[[ $filename =~ ^(canary|canary-debug)-([a-f0-9]{64})\.meta$ ]] || continue
		name=${BASH_REMATCH[1]}
		checksum=${BASH_REMATCH[2]}
		grep -qx 'format=canary-executable-backup-v1' "$metadata" || continue
		grep -qx "name=$name" "$metadata" || continue
		grep -qx "sha256=$checksum" "$metadata" || continue
		saved_at=$(sed -n 's/^saved_at_epoch=//p' "$metadata")
		[[ $saved_at =~ ^[1-9][0-9]{0,10}$ ]] || continue
		((now - saved_at > RETENTION_SECONDS)) || continue
		binary="${metadata%.meta}.bin"
		[[ -f $binary && ! -L $binary ]] || continue
		rm -- "$binary" "$metadata" || return 1
		info "Removed expired executable: ${binary##*/}"
	done
}

# Logs are first written to a private file in build/. Renaming that file over
# the public log path replaces a pre-existing symlink instead of following it.
start_log() {
	local log_file=$1
	local log_directory=${log_file%/*}
	[[ -d $log_directory && ! -L $log_directory ]] || return 1
	LOG_TEMP=$(mktemp "$log_directory/.recompile-log.XXXXXX")
}

finish_log() {
	local log_file=$1
	if ! mv -fT -- "$LOG_TEMP" "$log_file"; then
		rm -f -- "$LOG_TEMP"
		LOG_TEMP=""
		return 1
	fi
	LOG_TEMP=""
}

# tee keeps the complete log; pipefail retains command failures. No detached
# tail process, temporary progress marker or lost stderr is involved.
run_with_progress() {
	local label=$1 log_file=$2 pattern=$3 line current total command_status=0
	shift 3
	start_log "$log_file" || { error "Could not create a safe temporary log for $log_file"; return 1; }
	"$@" 2>&1 | tee "$LOG_TEMP" | while IFS= read -r line; do
		if [[ -t 1 && $line =~ $pattern ]]; then
			current=${BASH_REMATCH[1]}
			total=${BASH_REMATCH[2]}
			if ((total > 0)); then
				printf '\r[%s] %3d%% (%d/%d)\033[K' "$label" "$((current * 100 / total))" "$current" "$total"
			fi
		else
			printf '%s\n' "$line"
		fi
	done || command_status=$?
	finish_log "$log_file" || { error "Could not publish log: $log_file"; return 1; }
	return "$command_status"
}

build_has_pending_work() {
	local cmake_command=$1 plan_log="$WORKTREE_ROOT/build/build_plan_log.txt" command_status=0
	start_log "$plan_log" || { error "Could not create a safe temporary log for $plan_log"; return 2; }
	LC_ALL=C "$cmake_command" --build "$BUILD_DIRECTORY" --target "$EXECUTABLE_NAME" \
		--parallel "$BUILD_JOBS" -- -n >"$LOG_TEMP" 2>&1 || command_status=$?
	finish_log "$plan_log" || { error "Could not publish log: $plan_log"; return 2; }
	if ((command_status != 0)); then
		cat -- "$plan_log" >&2
		return 2
	fi
	# These presets use Ninja. Unknown output is treated as pending work;
	# an empty log or a command mentioning "up to date" is not proof of a no-op.
	if grep -qx 'ninja: no work to do\.' "$plan_log"; then
		return 1
	fi
	return 0
}

publish_executable() {
	local built="$BUILD_DIRECTORY/bin/$EXECUTABLE_NAME"
	local installed="$WORKTREE_ROOT/$EXECUTABLE_NAME"
	local checksum
	[[ -f $built && -x $built && ! -L $built ]] || die "Build did not produce the expected executable: $built"
	is_executable_elf "$built" || die "Build output is not an ELF executable: $built"
	checksum=$(digest "$built")
	archive_executable "$built" "$EXECUTABLE_NAME" || die "Could not archive the new executable."
	if [[ -f $installed && -x $installed && ! -L $installed && $(digest "$installed") == "$checksum" ]]; then
		info "Executable unchanged; no replacement or service restart is needed."
		return 0
	fi
	[[ ! -e $installed || -f $installed ]] || die "Installed executable path is not a regular file: $installed"
	[[ ! -L $installed ]] || die "Refusing to replace a symlinked executable: $installed"
	# Copy into the destination filesystem, verify it, then rename. A running
	# process keeps its old inode; a failed build/copy never truncates its binary.
	PUBLISH_TEMP=$(mktemp "$WORKTREE_ROOT/.$EXECUTABLE_NAME.install.XXXXXX")
	cp --preserve=mode -- "$built" "$PUBLISH_TEMP" || die "Could not stage the executable for installation."
	[[ $(digest "$PUBLISH_TEMP") == "$checksum" ]] || die "Installed copy failed SHA-256 verification."
	mv -fT -- "$PUBLISH_TEMP" "$installed" || die "Could not atomically install $installed"
	PUBLISH_TEMP=""
	EXECUTABLE_UPDATED=1
	info "Installed executable: $installed"
}

restart_service_if_requested() {
	((RESTART_SERVICE && EXECUTABLE_UPDATED)) || return 0
	check_command sudo
	[[ -x /usr/bin/systemctl ]] || die "systemctl not found at /usr/bin/systemctl"
	sudo -n /usr/bin/systemctl restart canary.service || die "New executable is installed, but canary.service could not be restarted."
	info "canary.service restarted."
}

main() {
	local command name cached_root cached_toolchain cmake_command path plan_status=0
	[[ $(uname -s) == Linux ]] || die "This entry point requires Linux."
	for command in flock sha256sum readelf git tee cut sed grep date realpath readlink mktemp cp mv rm; do
		check_command "$command"
	done
	BUILD_DIRECTORY="$WORKTREE_ROOT/build/$BUILD_TYPE"
	check_directories
	mkdir -p -- "$WORKTREE_ROOT/build"
	# Every preset can publish at the same repository root. Serialize that shared
	# output and the backup namespace, without locking other repositories.
	[[ ! -L "$WORKTREE_ROOT/build/.recompile.lock" ]] || die "Refusing a symlinked build lock."
	exec 9>>"$WORKTREE_ROOT/build/.recompile.lock"
	flock -n 9 || die "Another recompile.sh owns this repository's build/output lock."
	if cached_root=$(cache_value CMAKE_HOME_DIRECTORY); then
		[[ $(realpath -m -- "$cached_root") == "$WORKTREE_ROOT" ]] || die "The existing CMake cache belongs to a different source directory."
	fi
	if cmake_command=$(cache_value CMAKE_COMMAND); then
		[[ -f $cmake_command && -x $cmake_command ]] || die "The CMake recorded in this preset is unavailable: $cmake_command"
	else
		cmake_command=$(command -v cmake) || die "Required command not found: cmake"
	fi
	if [[ -n $VCPKG_PARENT_DIRECTORY ]]; then
		VCPKG_ROOT="$VCPKG_PARENT_DIRECTORY/vcpkg"
	elif [[ -z ${VCPKG_ROOT:-} ]] && cached_toolchain=$(cache_value CMAKE_TOOLCHAIN_FILE); then
		VCPKG_ROOT=${cached_toolchain%/scripts/buildsystems/vcpkg.cmake}
	else
		VCPKG_ROOT=${VCPKG_ROOT:-"$HOME/vcpkg"}
	fi
	VCPKG_ROOT=$(realpath -m -- "$VCPKG_ROOT")
	[[ -f "$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" ]] || die "vcpkg toolchain not found under $VCPKG_ROOT"
	if cached_toolchain=$(cache_value CMAKE_TOOLCHAIN_FILE); then
		[[ $(realpath -m -- "$cached_toolchain") == "$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" ]] || die "Use the vcpkg installation already configured in this preset."
	fi
	export VCPKG_ROOT
	export VCPKG_MAX_CONCURRENCY="$BUILD_JOBS"
	export CMAKE_BUILD_PARALLEL_LEVEL="$BUILD_JOBS"
	[[ $(uname -m) != aarch64* ]] || export VCPKG_FORCE_SYSTEM_BINARIES=1
	(umask 077; mkdir -p -- "$BACKUP_DIRECTORY")
	for name in canary canary-debug; do
		for path in "$WORKTREE_ROOT/$name" "$BUILD_DIRECTORY/bin/$name"; do
			[[ ! -L $path && ( ! -e $path || -f $path ) ]] || die "Expected a regular executable, not a link/directory: $path"
		done
		archive_executable "$WORKTREE_ROOT/$name" "$name" || die "Could not back up the installed executable."
		path="$BUILD_DIRECTORY/bin/$name"
		if [[ -f $path ]]; then
			if is_executable_elf "$path"; then
				archive_executable "$path" "$name" || die "Could not back up the previous build output."
			else
				info "Previous compiler output is incomplete; it will be rebuilt: $path"
			fi
		fi
		[[ ! "$WORKTREE_ROOT/$name" -ef "$BUILD_DIRECTORY/bin/$name" ]] || die "Compiler output is a hardlink to the installed executable."
	done
	archive_running_executables 1 || die "Running executable backup/preflight failed."
	cd -- "$WORKTREE_ROOT"
	info "Configuring $BUILD_TYPE in its existing build tree ($BUILD_JOBS jobs)."
	if ! run_with_progress vcpkg "$WORKTREE_ROOT/build/cmake_log.txt" '[[:space:]]([0-9]+)/([0-9]+)[[:space:]]' \
		"$cmake_command" --preset "$BUILD_TYPE" "${EXTRA_CMAKE_ARGS[@]}" \
		-DCMAKE_TOOLCHAIN_FILE="$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake" -DTOGGLE_BIN_FOLDER=ON; then
		die "CMake configuration failed. Installed executable kept. Log: build/cmake_log.txt"
	fi
	check_directories
	[[ $(cache_value CMAKE_CACHEFILE_DIR) == "$BUILD_DIRECTORY" ]] || die "Unexpected CMake binary directory."
	[[ $(cache_value TOGGLE_BIN_FOLDER) == ON ]] || die "CMake did not select the staged bin output directory."
	EXECUTABLE_NAME=$(cache_value CMAKE_PROJECT_NAME)
	[[ $EXECUTABLE_NAME == canary || $EXECUTABLE_NAME == canary-debug ]] || die "Unexpected CMake target: $EXECUTABLE_NAME"
	info "Checking for pending build work."
	build_has_pending_work "$cmake_command" || plan_status=$?
	case "$plan_status" in
		0)
			if ! run_with_progress Build "$WORKTREE_ROOT/build/build_log.txt" '^\[([0-9]+)/([0-9]+)\]' \
				"$cmake_command" --build "$BUILD_DIRECTORY" --target "$EXECUTABLE_NAME" --parallel "$BUILD_JOBS"; then
				die "Build failed. Installed executable kept. Log: build/build_log.txt"
			fi
			;;
		1) info "Build is up to date; reusing the existing compiler output." ;;
		*) die "Could not inspect pending build work. Installed executable kept. Log: build/build_plan_log.txt" ;;
	esac
	publish_executable
	# A server can restart during a long build. Refresh the actually running
	# version again immediately before considering any backup for expiry.
	archive_running_executables || die "Could not preserve a running version; backup cleanup skipped."
	prune_backups || die "Backup cleanup failed. The installed executable was kept."
	restart_service_if_requested
	info "Done. Backups: $BACKUP_DIRECTORY"
}

trap 'if [[ -n $PUBLISH_TEMP ]]; then rm -f -- "$PUBLISH_TEMP"; fi; if [[ -n $LOG_TEMP ]]; then rm -f -- "$LOG_TEMP"; fi' EXIT
parse_arguments "$@"
main
