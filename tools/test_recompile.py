#!/usr/bin/env python3
"""Test recompile.sh with temporary ELF fixtures; never compile Canary or restart a service."""

import fcntl
import hashlib
import json
import os
from pathlib import Path
import shlex
import shutil
import signal
import subprocess
import tempfile
import time
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "recompile.sh"
TRUE = Path("/bin/true").resolve()
FALSE = Path("/bin/false").resolve()
SLEEP = Path("/bin/sleep").resolve()
REAL_CMAKE = shutil.which("cmake")
REAL_NINJA = shutil.which("ninja")

CMAKE_FIXTURE = r'''#!/usr/bin/python3
import json, os, pathlib, shutil, sys, time
root = pathlib.Path(os.environ['RECOMPILE_FIXTURE_ROOT'])
assert (root / '.fixture').is_file()
args = sys.argv[1:]
with (root / 'calls.jsonl').open('a') as stream:
    stream.write(json.dumps(dict(args=args, vcpkg_jobs=os.environ.get('VCPKG_MAX_CONCURRENCY'),
                                 cmake_jobs=os.environ.get('CMAKE_BUILD_PARALLEL_LEVEL'),
                                 system_binaries=os.environ.get('VCPKG_FORCE_SYSTEM_BINARIES'))) + '\n')
mode = os.environ.get('FIXTURE_MODE', '')
if args[0] == '--preset':
    assert pathlib.Path.cwd() == root
    if mode == 'configure-fail':
        print('fixture configuration error', file=sys.stderr)
        sys.exit(23)
    preset = args[1]
    binary = root / 'build' / preset
    binary.mkdir(parents=True, exist_ok=True)
    definitions = [arg[2:] for arg in args if arg.startswith('-D')]
    toolchain = next(arg.split('=', 1)[1] for arg in definitions if arg.startswith('CMAKE_TOOLCHAIN_FILE='))
    name = 'canary-debug' if 'debug' in preset else 'canary'
    (binary / 'CMakeCache.txt').write_text(
        f'CMAKE_HOME_DIRECTORY:INTERNAL={root}\n'
        f'CMAKE_CACHEFILE_DIR:INTERNAL={binary}\n'
        f'CMAKE_COMMAND:INTERNAL={pathlib.Path(sys.argv[0]).resolve()}\n'
        f'CMAKE_TOOLCHAIN_FILE:FILEPATH={toolchain}\n'
        f'CMAKE_PROJECT_NAME:STATIC={name}\n'
        'TOGGLE_BIN_FOLDER:BOOL=ON\n')
    print('Installing 1/2 fixture dependency')
elif args[0] == '--build':
    binary = pathlib.Path(args[1])
    assert binary.parent == root / 'build'
    if args[-2:] == ['--', '-n']:
        if mode == 'plan-fail':
            print('fixture build plan error', file=sys.stderr)
            sys.exit(29)
        if mode == 'no-work':
            print('ninja: no work to do.')
        elif mode != 'empty-plan':
            print('[1/1] fixture pending build')
        sys.exit(0)
    target = args[args.index('--target') + 1]
    output = binary / 'bin' / target
    output.parent.mkdir(parents=True, exist_ok=True)
    if mode == 'slow':
        (root / 'building').touch()
        time.sleep(120)
    if mode == 'missing':
        sys.exit(0)
    if mode in ('build-fail', 'invalid'):
        output.write_text('incomplete fixture output')
        output.chmod(0o755)
        print('fixture build error', file=sys.stderr)
        sys.exit(37 if mode == 'build-fail' else 0)
    shutil.copy2(os.environ['FIXTURE_BINARY'], output)
    print('[1/2] fixture build step')
    print('[2/2] fixture link step')
else:
    raise AssertionError(args)
'''

SUDO_FIXTURE = r'''#!/usr/bin/python3
import json, os, pathlib, sys
root = pathlib.Path(os.environ['RECOMPILE_FIXTURE_ROOT'])
assert (root / '.fixture').is_file()
(root / 'restart.json').write_text(json.dumps(sys.argv[1:]))
sys.exit(int(os.environ.get('FIXTURE_RESTART_STATUS', '0')))
'''

COPY_FIXTURE = r'''#!/usr/bin/python3
import os, sys
if '.install.' in sys.argv[-1]:
    sys.exit(41)
os.execv('/bin/cp', ['cp', *sys.argv[1:]])
'''


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


class RecompileTest(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="recompile-fixture-")
        self.addCleanup(self.temp.cleanup)
        self.directory = Path(self.temp.name)
        self.root = self.directory / "source with spaces"
        self.root.mkdir()
        (self.root / ".fixture").touch()
        self.script = self.root / "recompile.sh"
        self.script.write_bytes(SCRIPT.read_bytes())
        self.installed = self.root / "canary"
        shutil.copy2(TRUE, self.installed)
        self.backups = self.root / "backups" / "executables"
        self.tools = self.directory / "fixture-tools"
        self.tools.mkdir()
        self.write_tool("cmake", CMAKE_FIXTURE)
        self.write_tool("sudo", SUDO_FIXTURE)
        self.vcpkg_parent = self.directory / "toolchain with spaces"
        toolchain = self.vcpkg_parent / "vcpkg/scripts/buildsystems/vcpkg.cmake"
        toolchain.parent.mkdir(parents=True)
        toolchain.write_text("# Inert fixture; never included by a real CMake.\n")
        self.environment = dict(os.environ)
        for name in ("CMAKE_BUILD_PARALLEL_LEVEL", "VCPKG_ROOT", "VCPKG_FORCE_SYSTEM_BINARIES", "BASH_ENV", "ENV"):
            self.environment.pop(name, None)
        self.environment.update(
            PATH=f"{self.tools}:/usr/bin:/bin",
            RECOMPILE_FIXTURE_ROOT=str(self.root),
            FIXTURE_BINARY=str(FALSE),
            HOME=str(self.vcpkg_parent),
        )

    def write_tool(self, name, source):
        path = self.tools / name
        path.write_text(source)
        path.chmod(0o755)

    def run_script(self, *args, expected=0, **environment):
        result = subprocess.run(
            ["/bin/bash", str(self.script), *map(str, args)],
            cwd=self.directory,
            env=dict(self.environment, **environment),
            text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=20,
        )
        if expected == 0:
            self.assertEqual(0, result.returncode, result.stdout)
        else:
            self.assertNotEqual(0, result.returncode, result.stdout)
        return result

    def calls(self):
        path = self.root / "calls.jsonl"
        return [json.loads(line) for line in path.read_text().splitlines()] if path.exists() else []

    def record(self, binary, name="canary"):
        path = self.backups / f"{name}-{digest(binary)}.meta"
        return dict(line.split("=", 1) for line in path.read_text().splitlines())

    def old_backup(self, binary=SLEEP, days=8, managed=True):
        self.backups.mkdir(parents=True, exist_ok=True)
        checksum = digest(binary)
        stem = self.backups / f"canary-{checksum}"
        shutil.copy2(binary, Path(str(stem) + ".bin"))
        Path(str(stem) + ".meta").write_text(
            f"format={'canary-executable-backup-v1' if managed else 'operator-owned'}\n"
            f"name=canary\nsha256={checksum}\nsaved_at_epoch={int(time.time()) - days * 86400}\n"
        )
        return Path(str(stem) + ".bin")

    def start_sleep(self, path):
        process = subprocess.Popen([str(path), "120"])

        def stop():
            if process.poll() is None:
                process.terminate()
            process.wait(timeout=5)

        self.addCleanup(stop)
        for _ in range(50):
            if digest(f"/proc/{process.pid}/exe") == digest(SLEEP):
                break
            time.sleep(0.01)
        return process

    def test_help_and_invalid_arguments_do_not_build(self):
        self.run_script("--help")
        for args in (("--jobs", "0"), ("--",), ("--unknown",), ("--", "-B/tmp/elsewhere"),
                     ("--", "-DTOGGLE_BIN_FOLDER=OFF"), ("--", "--preset=another")):
            self.run_script(*args, expected=1)
        self.assertFalse((self.root / "build").exists())
        self.assertFalse(self.backups.exists())
        self.assertFalse(self.calls())

    def test_archives_exact_old_and_new_elf_and_installs_new_binary(self):
        previous_inode = self.installed.stat().st_ino
        self.run_script("--jobs", "1", "--", "-DOPTIONS_ENABLE_OPENMP=OFF")
        self.assertEqual(digest(FALSE), digest(self.installed))
        self.assertNotEqual(previous_inode, self.installed.stat().st_ino)
        for binary in (TRUE, FALSE):
            record = self.record(binary)
            self.assertEqual(digest(binary), record["sha256"])
            self.assertNotEqual("unavailable", record["build_id"])
            self.assertEqual(binary.read_bytes(), (self.backups / f"canary-{digest(binary)}.bin").read_bytes())
        calls = self.calls()
        self.assertEqual(["--preset", "linux-release"], calls[0]["args"][:2])
        self.assertIn("-DTOGGLE_BIN_FOLDER=ON", calls[0]["args"])
        self.assertIn("-DOPTIONS_ENABLE_OPENMP=OFF", calls[0]["args"])
        self.assertEqual(["--", "-n"], calls[1]["args"][-2:])
        self.assertEqual(["--parallel", "1"], calls[2]["args"][-2:])
        self.assertEqual("1", calls[0]["vcpkg_jobs"])
        self.assertEqual("1", calls[0]["cmake_jobs"])
        self.assertFalse((self.root / "restart.json").exists())

    def test_explicit_jobs_override_inherited_cmake_parallelism(self):
        self.run_script("--jobs", "1", CMAKE_BUILD_PARALLEL_LEVEL="17")
        self.assertTrue(all(call["cmake_jobs"] == "1" for call in self.calls()))

    def test_matching_nonexecutable_file_is_reinstalled_and_restarted(self):
        inode = self.installed.stat().st_ino
        self.installed.chmod(0o644)
        self.run_script("--restart-service", FIXTURE_BINARY=str(TRUE))
        self.assertNotEqual(inode, self.installed.stat().st_ino)
        self.assertTrue(os.access(self.installed, os.X_OK))
        self.assertTrue((self.root / "restart.json").exists())

    def test_no_change_deduplicates_and_does_not_restart_or_replace(self):
        inode = self.installed.stat().st_ino
        self.run_script("--restart-service", FIXTURE_BINARY=str(TRUE))
        self.run_script("--restart-service", FIXTURE_BINARY=str(TRUE))
        self.assertEqual(inode, self.installed.stat().st_ino)
        self.assertEqual(1, len(list(self.backups.glob("*.bin"))))
        self.assertFalse((self.root / "restart.json").exists())

    def test_compile_mtime_does_not_expire_a_new_backup(self):
        os.utime(self.installed, (1, 1))
        self.run_script()
        self.assertGreater(int(self.record(TRUE)["saved_at_epoch"]), time.time() - 30)

    def test_retention_deletes_only_expired_managed_pairs_even_on_noop(self):
        expired = self.old_backup()
        recent = self.old_backup(Path("/bin/echo"), days=6)
        unknown = self.old_backup(Path("/bin/cat"), managed=False)
        sentinel = self.backups / "operator-notes.txt"
        sentinel.write_text("keep")
        self.run_script(FIXTURE_BINARY=str(TRUE))
        self.assertFalse(expired.exists())
        self.assertFalse(expired.with_suffix(".meta").exists())
        for path in (recent, unknown, sentinel):
            self.assertTrue(path.exists())

    def test_failure_preserves_runtime_and_does_not_prune_or_restart(self):
        for mode in ("configure-fail", "plan-fail", "build-fail", "missing", "invalid"):
            with self.subTest(mode=mode):
                staged = self.root / "build/linux-release/bin/canary"
                if staged.exists():
                    staged.unlink()
                expired = self.old_backup()
                before = self.installed.read_bytes()
                inode = self.installed.stat().st_ino
                self.run_script("--restart-service", expected=1, FIXTURE_MODE=mode)
                self.assertEqual(before, self.installed.read_bytes())
                self.assertEqual(inode, self.installed.stat().st_ino)
                self.assertTrue(expired.exists())
                self.assertFalse((self.root / "restart.json").exists())
        self.assertIn("fixture build error", (self.root / "build/build_log.txt").read_text())

    def test_copy_failure_never_replaces_installed_file(self):
        self.write_tool("cp", COPY_FIXTURE)
        self.run_script("--restart-service", expected=1)
        self.assertEqual(digest(TRUE), digest(self.installed))
        self.assertFalse(list(self.root.glob(".canary.install.*")))
        self.assertFalse((self.root / "restart.json").exists())

    def test_retry_after_failed_link_rebuilds_incomplete_staging_output(self):
        self.run_script(expected=1, FIXTURE_MODE="build-fail")
        self.run_script()
        self.assertEqual(digest(FALSE), digest(self.installed))
        self.assertEqual(digest(TRUE), self.record(TRUE)["sha256"])

    def test_cmake_arguments_are_forwarded_without_shell_expansion(self):
        argument = "-DFIXTURE_TEXT=literal $(touch must-not-exist); with spaces"
        self.run_script("--", argument)
        self.assertIn(argument, self.calls()[0]["args"])
        self.assertFalse((self.root / "must-not-exist").exists())

    def test_existing_cache_toolchain_is_reused_when_environment_is_unset(self):
        self.run_script()
        self.environment["HOME"] = str(self.directory / "unused home")
        self.run_script()
        self.assertEqual(6, len(self.calls()))

    def test_cached_cmake_is_reused_instead_of_a_different_path_version(self):
        self.run_script()
        maintained = self.directory / "maintained cmake" / "cmake"
        maintained.parent.mkdir()
        original = self.tools / "cmake"
        original.rename(maintained)
        cache = self.root / "build/linux-release/CMakeCache.txt"
        cache.write_text(cache.read_text().replace(
            f"CMAKE_COMMAND:INTERNAL={original}", f"CMAKE_COMMAND:INTERNAL={maintained}"))
        self.write_tool("cmake", "#!/bin/sh\nexit 42\n")
        self.run_script()
        self.assertEqual(6, len(self.calls()))

    def test_unavailable_cached_cmake_does_not_reconfigure_or_replace(self):
        self.run_script()
        inode = self.installed.stat().st_ino
        (self.tools / "cmake").unlink()
        result = self.run_script(expected=1)
        self.assertIn("CMake recorded in this preset is unavailable", result.stdout)
        self.assertEqual(3, len(self.calls()))
        self.assertEqual(inode, self.installed.stat().st_ino)

    def test_foreign_cache_or_toolchain_is_not_reconfigured(self):
        build = self.root / "build/linux-release"
        build.mkdir(parents=True)
        cache = build / "CMakeCache.txt"
        for content in (
            f"CMAKE_HOME_DIRECTORY:INTERNAL={self.directory}\n",
            f"CMAKE_HOME_DIRECTORY:INTERNAL={self.root}\nCMAKE_TOOLCHAIN_FILE:FILEPATH=/unrelated/toolchain.cmake\n",
        ):
            cache.write_text(content)
            self.run_script(self.vcpkg_parent, expected=1)
            self.assertFalse(self.calls())

    def test_backup_failure_stops_before_configuration(self):
        self.backups.mkdir(parents=True)
        (self.backups / f"canary-{digest(TRUE)}.bin").write_text("corrupted")
        self.run_script(expected=1)
        self.assertFalse(self.calls())
        self.assertEqual(digest(TRUE), digest(self.installed))

    def test_restart_requires_flag_and_new_binary(self):
        self.run_script("--restart-service")
        self.assertEqual(["-n", "/usr/bin/systemctl", "restart", "canary.service"],
                         json.loads((self.root / "restart.json").read_text()))

    def test_restart_failure_reports_new_binary_without_rollback(self):
        self.run_script("--restart-service", expected=1, FIXTURE_RESTART_STATUS="1")
        self.assertEqual(digest(FALSE), digest(self.installed))
        self.assertEqual(digest(TRUE), self.record(TRUE)["sha256"])

    def test_debug_preset_and_explicit_vcpkg_path_with_spaces(self):
        self.run_script(self.vcpkg_parent, "linux-debug-asan", "--jobs=2")
        self.assertEqual(digest(FALSE), digest(self.root / "canary-debug"))
        self.assertEqual(digest(TRUE), digest(self.installed))
        self.assertIn("canary-debug", self.calls()[1]["args"])
        self.assertEqual(digest(FALSE), self.record(FALSE, "canary-debug")["sha256"])

    def test_legacy_cmake_definitions_are_forwarded_and_managed_paths_still_rejected(self):
        self.run_script(self.vcpkg_parent, "linux-release", "-DOPTIONS_ENABLE_OPENMP=OFF")
        self.assertIn("-DOPTIONS_ENABLE_OPENMP=OFF", self.calls()[0]["args"])
        previous_calls = len(self.calls())
        self.run_script(self.vcpkg_parent, "linux-release", "-DTOGGLE_BIN_FOLDER=OFF", expected=1)
        self.assertEqual(previous_calls, len(self.calls()))

    def test_arm64_keeps_vcpkg_system_binary_selection(self):
        self.write_tool("uname", '#!/bin/sh\ncase "$1" in -s) echo Linux;; -m) echo aarch64;; *) exit 1;; esac\n')
        self.run_script()
        self.assertEqual("1", self.calls()[0]["system_binaries"])

    def test_no_pending_work_skips_build_and_still_prunes_expired_backups(self):
        staged = self.root / "build/linux-release/bin/canary"
        staged.parent.mkdir(parents=True)
        shutil.copy2(TRUE, staged)
        expired = self.old_backup()
        inode = self.installed.stat().st_ino
        self.run_script("--restart-service", FIXTURE_MODE="no-work")
        self.assertEqual(2, len(self.calls()))
        self.assertEqual(["--", "-n"], self.calls()[1]["args"][-2:])
        self.assertEqual(inode, self.installed.stat().st_ino)
        self.assertFalse(expired.exists())
        self.assertFalse((self.root / "restart.json").exists())

    def test_no_pending_work_still_requires_a_valid_output(self):
        self.run_script("--restart-service", expected=1, FIXTURE_MODE="no-work")
        self.assertEqual(digest(TRUE), digest(self.installed))
        self.assertFalse((self.root / "restart.json").exists())

    def test_empty_dry_run_output_is_not_assumed_to_mean_no_work(self):
        self.run_script(FIXTURE_MODE="empty-plan")
        self.assertEqual(3, len(self.calls()))
        self.assertEqual(digest(FALSE), digest(self.installed))

    @unittest.skipUnless(REAL_CMAKE and REAL_NINJA, "CMake and Ninja are needed for the copy-only smoke test")
    def test_real_cmake_ninja_copy_only_success_noop_and_failed_build(self):
        self.write_tool("cmake", '#!/bin/sh\nexec ' + shlex.quote(REAL_CMAKE) + ' "$@"\n')
        self.write_tool("ninja", '#!/bin/sh\nexec ' + shlex.quote(REAL_NINJA) + ' "$@"\n')
        shutil.copy2(FALSE, self.root / "fixture-binary")
        (self.root / "CMakePresets.json").write_text(json.dumps({
            "version": 3,
            "configurePresets": [{"name": "linux-release", "generator": "Ninja",
                                  "binaryDir": "${sourceDir}/build/${presetName}"}],
        }))
        (self.root / "CMakeLists.txt").write_text('''cmake_minimum_required(VERSION 3.24)
project(canary LANGUAGES NONE)
option(FIXTURE_FAIL "Fail the copy-only target" OFF)
if(FIXTURE_FAIL)
    add_custom_target(canary COMMAND "${CMAKE_COMMAND}" -E false)
else()
    add_custom_command(OUTPUT "${CMAKE_BINARY_DIR}/bin/canary"
        COMMAND "${CMAKE_COMMAND}" -E make_directory "${CMAKE_BINARY_DIR}/bin"
        COMMAND "${CMAKE_COMMAND}" -E copy "${CMAKE_SOURCE_DIR}/fixture-binary" "${CMAKE_BINARY_DIR}/bin/canary"
        DEPENDS "${CMAKE_SOURCE_DIR}/fixture-binary" VERBATIM)
    add_custom_target(canary DEPENDS "${CMAKE_BINARY_DIR}/bin/canary")
endif()
''')
        self.run_script()
        self.assertEqual(digest(FALSE), digest(self.installed))
        self.assertEqual(digest(TRUE), self.record(TRUE)["sha256"])
        inode = self.installed.stat().st_ino
        first_build_log = (self.root / "build/build_log.txt").read_bytes()
        result = self.run_script("--restart-service")
        self.assertIn("Build is up to date", result.stdout)
        self.assertEqual(first_build_log, (self.root / "build/build_log.txt").read_bytes())
        self.assertEqual(inode, self.installed.stat().st_ino)
        self.assertFalse((self.root / "restart.json").exists())
        self.run_script("--restart-service", "--", "-DFIXTURE_FAIL=ON", expected=1)
        self.assertEqual(inode, self.installed.stat().st_ino)
        self.assertEqual(digest(FALSE), digest(self.installed))
        self.assertFalse((self.root / "restart.json").exists())

    def test_lock_rejects_overlapping_scripts(self):
        build = self.root / "build"
        build.mkdir()
        with (build / ".recompile.lock").open("a") as lock:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            self.run_script(expected=1)
        self.assertFalse(self.calls())

    def test_symlinked_backup_root_cannot_delete_external_files(self):
        outside = self.directory / "outside"
        outside.mkdir()
        sentinel = outside / "keep"
        sentinel.write_text("keep")
        (self.root / "backups").symlink_to(outside, target_is_directory=True)
        self.run_script(expected=1)
        self.assertEqual([sentinel], list(outside.iterdir()))
        self.assertFalse(self.calls())

    def test_symlinked_cmake_cache_is_rejected_without_touching_its_target(self):
        outside = self.directory / "outside-cache"
        outside.write_text("keep")
        build = self.root / "build/linux-release"
        build.mkdir(parents=True)
        (build / "CMakeCache.txt").symlink_to(outside)
        self.run_script(expected=1)
        self.assertEqual("keep", outside.read_text())
        self.assertFalse(self.calls())

    def test_log_symlinks_are_replaced_without_touching_their_targets(self):
        build = self.root / "build"
        build.mkdir()
        sentinels = []
        for name in ("cmake_log.txt", "build_plan_log.txt", "build_log.txt"):
            outside = self.directory / f"outside-{name}"
            outside.write_text("keep")
            (build / name).symlink_to(outside)
            sentinels.append(outside)
        self.run_script()
        for outside in sentinels:
            self.assertEqual("keep", outside.read_text())
        for name in ("cmake_log.txt", "build_plan_log.txt", "build_log.txt"):
            log = build / name
            self.assertTrue(log.is_file())
            self.assertFalse(log.is_symlink())

    def test_symlinked_or_hardlinked_output_is_rejected_before_build(self):
        staged = self.root / "build/linux-release/bin/canary"
        staged.parent.mkdir(parents=True)
        staged.symlink_to(self.installed)
        self.run_script(expected=1)
        staged.unlink()
        os.link(self.installed, staged)
        self.run_script(expected=1)
        self.assertEqual(digest(TRUE), digest(self.installed))
        self.assertFalse(self.calls())

    def test_expired_symlink_backup_is_kept_without_touching_target(self):
        expired = self.old_backup()
        outside = self.directory / "outside.bin"
        outside.write_text("keep")
        expired.unlink()
        expired.symlink_to(outside)
        self.run_script()
        self.assertTrue(expired.is_symlink())
        self.assertEqual("keep", outside.read_text())

    def test_running_old_inode_is_preserved_and_kept_past_retention(self):
        shutil.copy2(SLEEP, self.installed)
        process = self.start_sleep(self.installed)
        expired = self.old_backup()
        replacement = self.root / "replacement"
        shutil.copy2(TRUE, replacement)
        replacement.replace(self.installed)
        self.run_script()
        self.assertIsNone(process.poll())
        self.assertEqual(digest(SLEEP), digest(f"/proc/{process.pid}/exe"))
        self.assertEqual(digest(FALSE), digest(self.installed))
        self.assertTrue(expired.exists())
        self.assertGreater(int(self.record(SLEEP)["saved_at_epoch"]), time.time() - 30)

    def test_running_compiler_output_blocks_relink(self):
        staged = self.root / "build/linux-release/bin/canary"
        staged.parent.mkdir(parents=True)
        shutil.copy2(SLEEP, staged)
        process = self.start_sleep(staged)
        self.run_script(expected=1)
        self.assertFalse(self.calls())
        self.assertIsNone(process.poll())

    def test_interrupt_during_build_keeps_installed_binary(self):
        process = subprocess.Popen(
            ["/bin/bash", str(self.script)], cwd=self.directory,
            env=dict(self.environment, FIXTURE_MODE="slow"), start_new_session=True,
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
        )
        try:
            deadline = time.monotonic() + 10
            while not (self.root / "building").exists() and time.monotonic() < deadline:
                self.assertIsNone(process.poll())
                time.sleep(0.02)
            self.assertTrue((self.root / "building").exists())
        finally:
            os.killpg(process.pid, signal.SIGTERM)
            process.wait(timeout=5)
        self.assertEqual(digest(TRUE), digest(self.installed))
        self.assertFalse((self.root / "restart.json").exists())


if __name__ == "__main__":
    unittest.main()
