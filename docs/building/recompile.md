# Recompile on Linux with executable history

[`recompile.sh`](../../recompile.sh) configures and builds Canary, installs the
result at the checkout root, and keeps exact copies of previous executables.
This lets an operator match a crash dump to the binary that actually produced
it, even after another version has been installed.

The default run **replaces the installed executable but does not restart the
server**. A running Linux process continues using its previous executable.
Restarting through the script requires `--restart-service`.

- [Requirements](#requirements)
- [Usage and options](#usage-and-options)
- [Build and installation](#build-and-installation)
- [Seven-day retention](#seven-day-retention)
- [Investigating a crash](#investigating-a-crash)
- [Windows and WSL](#windows-and-wsl)
- [Validation without compiling Canary](#validation-without-compiling-canary)
- [Troubleshooting](#troubleshooting)

## Requirements

Run this script in Linux, including Linux under WSL. It produces Linux ELF
executables. For native Windows builds, use the
[Windows CMake guide](<windows-(cmake).md>).

Set up the compiler, Ninja and vcpkg using the [Ubuntu](ubuntu-24.04.md) or
[Debian](debian.md) guide first. CMake must meet the minimum in
[`CMakePresets.json`](../../CMakePresets.json), currently 3.24. The script also
uses Bash, Git, GNU coreutils, `grep`, `sed`, `readelf` from binutils and `flock`
from util-linux. Python 3 and ShellCheck are needed only for the tests below.

Use an account that can read the relevant executables and write to this
checkout. Reading a running executable through Linux `/proc` also requires
appropriate process permissions. If a Canary process cannot be inspected, the
script skips expired-backup cleanup for that invocation.

The script reuses the selected CMake build tree and dependency caches. It does
not install system packages, fetch source updates, switch branches, update the
database or install a system service.

On Linux ARM64 (`aarch64`), it retains vcpkg's system-binary selection through
`VCPKG_FORCE_SYSTEM_BINARIES=1`. Build and dependency output is shown live and
saved to logs; interactive terminals also show parsed progress percentages.

## Usage and options

Run these examples from the repository root:

```bash
# Inspect the options without creating files or building.
bash ./recompile.sh --help

# Configure, build and install, using at most two parallel jobs.
bash ./recompile.sh --jobs 2

# Use vcpkg/ under the parent directory and select a debug preset.
bash ./recompile.sh .. linux-debug --jobs 1

# Forward an additional CMake definition.
bash ./recompile.sh --jobs 2 -- -DOPTIONS_ENABLE_OPENMP=OFF
```

The script locates its checkout from its own path, so it also works when called
from another directory. Relative vcpkg paths are resolved from the caller's
working directory.

| Argument | Default | Meaning |
| --- | --- | --- |
| First positional argument | Environment, cache, then home | Directory **containing** `vcpkg/`, not the toolchain file or the vcpkg directory itself |
| Second positional argument | `linux-release` | Linux configure preset from `CMakePresets.json`, using `build/<preset>` |
| `--jobs N`, `-j N` | `CMAKE_BUILD_PARALLEL_LEVEL`, otherwise `2` | Limit both the build and vcpkg to a positive job count below 1000 |
| `-- <cmake-options...>` | None | Forward CMake options as individual arguments; quote values containing spaces |
| `--restart-service` | Disabled | Restart `canary.service` after installing a different executable |
| `--help`, `-h` | — | Print help and exit without building or modifying files |

Without the first positional argument, vcpkg is selected in this order:
`VCPKG_ROOT`, the toolchain already recorded in this preset's cache, then
`$HOME/vcpkg`. An explicit selection must match an existing cache's toolchain.
The script also reuses the cache's `CMAKE_COMMAND`; a different CMake version
earlier in `PATH` does not silently replace it.

### Migrating an existing command

The previous form still accepts CMake definitions after both positional
arguments:

```bash
bash ./recompile.sh "$HOME" linux-release -DOPTIONS_ENABLE_OPENMP=OFF
```

Prefer `--` in new commands and put script options such as `--jobs` before
the CMake options. Output management is now fixed: the script configures
`TOGGLE_BIN_FOLDER=ON`, links inside `build/<preset>/bin`, and installs a
verified copy at the checkout root. Overrides for the source/build directory,
generator, preset, toolchain or `TOGGLE_BIN_FOLDER` are rejected.

Older `canary.old` or `canary-debug.old` files are left untouched. Keep them if
they are still needed for older crash dumps; the new retention process does
not import or delete them.

## Build and installation

Each invocation follows this sequence:

1. Acquire the checkout's build/output lock and validate existing paths,
   CMake cache and toolchain.
2. Back up installed executables, valid previous output from this preset and
   matching running executables, including an older unlinked executable.
3. Configure the existing preset and inspect pending work with a Ninja dry
   run. Build its `canary` or `canary-debug` target with the requested
   parallelism, or reuse the existing output when Ninja reports no work.
4. Validate and archive the new ELF. Copy it to a temporary file beside the
   installed executable, verify its SHA-256, then rename it into place.
5. Refresh backups of running versions and remove eligible expired backups.
6. Restart the service only if requested and a different binary was installed.

If the new SHA-256 matches the installed file, the script preserves that file
and skips the restart. Configure, link or staging-copy failures leave the
installed executable intact. Existing dependencies and build intermediates
can still change during a failed build.

A failed build-plan inspection also stops the invocation. Reusing up-to-date
output still requires a valid executable, verifies its hash and applies backup
retention; an empty or unfamiliar dry-run response is treated as pending work.
This entry point builds the server target. Use the standard
[test workflow](../../tests/README.md) to build and run the full test suite.

| Location | Contents |
| --- | --- |
| `build/<preset>/` | Reused CMake/Ninja state and build intermediates |
| `build/<preset>/bin/canary` or `canary-debug` | Compiler output |
| `canary` or `canary-debug` at the checkout root | Installed executable |
| `backups/executables/` | Binary copies and their metadata, ignored by Git |
| `build/cmake_log.txt` | Configure/vcpkg output from the latest invocation |
| `build/build_plan_log.txt` | Latest Ninja dry-run output |
| `build/build_log.txt` | Build output from the latest build step |
| `build/.recompile.lock` | Lock shared by script invocations in this checkout |

The lock covers all presets because they publish into the same checkout root.
Manual CMake/Ninja commands do not acquire it: do not run them against the same
build tree or installed output while this script is running.

Run the server from the installed root executable. If the process runs directly
from this preset's compiler output, the script refuses to relink over it.
Use a separate checkout for compilation or move to the installed executable
during a planned restart before adopting this workflow.

### Optional systemd restart

```bash
bash ./recompile.sh --jobs 2 --restart-service
```

This invokes `sudo -n /usr/bin/systemctl restart canary.service`. It requires
that unit to exist and the invoking account to have the corresponding
non-interactive sudo permission. No permission or service is created by the
script. Servers managed by a terminal, a launcher or another unit should use
their existing restart procedure instead.

A restart failure is reported after installation; it does not roll the binary
back automatically. Likewise, the script does not test gameplay or revert data
migrations. Executable recovery and database recovery are separate operations.

## Seven-day retention

Each distinct executable has a pair of files:

```text
backups/executables/
  canary-<sha256>.bin
  canary-<sha256>.meta
  canary-debug-<sha256>.bin
  canary-debug-<sha256>.meta
```

The binary is copied byte for byte; no compression or stripping is performed.
Identical binaries share one backup. Metadata records the SHA-256, ELF Build
ID when available, backup time and checkout commit observed at backup time.
The `checkout_at_backup` field is **not proof of the commit that compiled an
older binary**. Use binary identity when matching a dump.

Retention is based on **last use or backup by this script**, not compilation
time. An installed or running version has its timestamp refreshed and can be
kept longer than a week. After a successful invocation, including one with no
binary change, managed pairs unused for more than seven days are removed.

Cleanup runs only when the script runs. It installs no timer or scheduled job,
and failed builds do not prune backups. This is an age policy, not a disk-size
quota; allow space for distinct binaries, the build output and installation
staging. Preserve a needed binary/core pair separately before its retention
period expires.

Only recognized binary/metadata pairs in this directory are eligible for
deletion. Unrelated files, old `.old` files, symlinks and core dumps are outside
cleanup. Symlinked build/backup directories and compiler output hardlinked to
the installed executable are rejected.

## Investigating a crash

A useful crash investigation needs the **core dump and its matching
executable**. Core generation must already be enabled for the server's launch
method. This script preserves executables; it does not configure kernel or
systemd core-dump policy, attach GDB or archive shared libraries.

Use metadata and `readelf -n` to select a backup. Replace `SHA256` and `PID`
below with the actual backup hash and dump filename:

```bash
readelf -n backups/executables/canary-SHA256.bin
gdb backups/executables/canary-SHA256.bin core.PID
```

Inside GDB, `thread apply all bt full` prints thread backtraces and available
local variables. Default `linux-release` uses `RelWithDebInfo`; keep any
separately stored debug symbols and required libraries with the incident
artifacts. Copying a stripped binary preserves its identity but cannot restore
debug information already removed from it.

Building the same source commit again does not guarantee an identical
executable: compiler, dependencies and build settings can differ. Prefer the
original binary retained by the script.

## Windows and WSL

PowerShell does not interpret Bash scripts. With WSL installed and the current
directory set to this repository, run:

```powershell
wsl --list --quiet
wsl -d Ubuntu -- bash ./recompile.sh --help
wsl -d Ubuntu -- python3 ./tools/test_recompile.py -v
```

Replace `Ubuntu` with the installed distribution's name if needed. The tests
use temporary Linux fixtures and do not compile or start Canary. A normal
build through WSL produces a Linux executable, even when launched from
PowerShell. See the [WSL setup guide](wsl-ubuntu-24.04.md) for prerequisites.

## Validation without compiling Canary

Run from the repository root in Linux or WSL:

```bash
bash -n recompile.sh
shellcheck recompile.sh
python3 tools/test_recompile.py -v
```

The test suite invokes the real script in temporary directories. Most cases
substitute inert CMake/sudo tools and use small existing ELF utilities as
fixtures. A CMake/Ninja smoke test copies an existing ELF with no compiler
enabled. Together they cover retention, hashes, deduplication, failed builds,
interruption, cache reuse, command compatibility, output locks, optional
restart requests, ARM64 environment selection and preservation of a running
old executable. They also verify dry-run failure and up-to-date behavior.

No game database or real service is used. The dedicated
[`recompile script` workflow](../../.github/workflows/recompile.yml) runs these
checks for relevant pull requests.

## Troubleshooting

| Symptom | Meaning and next step |
| --- | --- |
| PowerShell does not recognize the command | Invoke Bash through WSL as shown above |
| Required command or toolchain missing | Complete the Linux prerequisites and check the selected vcpkg installation |
| Cached CMake is unavailable | Restore the CMake recorded in this preset or repair the cache through the [local build workflow](local-validation.md#cache-recovery) |
| Cache belongs to a different source directory | Use that checkout's maintained build tree; do not reuse another worktree's cache |
| Build/output lock is occupied | Wait for the other invocation to finish; do not remove its lock |
| Process runs from compiler output | Use a separate build checkout or switch the launcher to the installed root executable during planned maintenance |
| Backup verification failed | Inspect disk space, access and the reported backup; the script stops before configuring |
| Configuration/build failed | Inspect the corresponding log; the installed executable and older backups are retained |
| Build-plan inspection failed | Inspect `build/build_plan_log.txt`; the script did not start the build |
| Backup cleanup failed after installation | The new executable is already installed; inspect the reported path before retrying |
| Service restart failed | The new executable is installed and backed up; inspect the unit and restart permissions |
