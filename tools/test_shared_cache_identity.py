#!/usr/bin/env python3
"""Exercise the real resolver in read-only CMake script mode; never build packages."""

import argparse
import json
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


MODULE = Path(__file__).resolve().parents[1] / "cmake/SharedBuildCache.cmake"
CMAKE = shutil.which("cmake")


class SharedCacheIdentity(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="shared-cache-identity-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.source = self.root / "source"
        self.binary = self.root / "consumer"
        self.pool = self.root / "pool"
        self.vcpkg = self.root / "vcpkg"
        self.vs = self.root / "visual-studio"
        self.source.mkdir()
        self.binary.mkdir()
        self.module = self.source / "SharedBuildCache.cmake"
        self.module.write_bytes(MODULE.read_bytes())
        self.write(
            "source/vcpkg.json",
            json.dumps(
                {"name": "fixture", "version-string": "1", "dependencies": ["zlib"]}
            ),
        )
        self.write("vcpkg/vcpkg.exe", "fixture vcpkg (not executable)")
        self.write("vcpkg/vcpkg", "fixture vcpkg (not executable)")
        self.write(
            "vcpkg/scripts/buildsystems/vcpkg.cmake",
            "# fixture toolchain: never included\n",
        )
        self.write(
            "vcpkg/triplets/x64-test.cmake", "set(VCPKG_TARGET_ARCHITECTURE x64)\n"
        )
        self.write("compiler/c.exe", "fixture C compiler (not executable)")
        self.write("compiler/cxx.exe", "fixture C++ compiler (not executable)")
        self.write(
            "visual-studio/VC/Auxiliary/Build/vcvarsall.bat", "fixture environment"
        )
        self.write(
            "visual-studio/VC/Tools/MSVC/14.0/bin/Hostx64/x64/cl.exe",
            "fixture dependency compiler",
        )
        self.write(
            "visual-studio/MSBuild/Current/Bin/amd64/MSBuild.exe",
            "fixture dependency MSBuild",
        )
        self.write("consumer-tool/MSBuild.exe", "fixture consumer MSBuild")
        self.env = {
            key: value
            for key, value in os.environ.items()
            if not key.upper().startswith(("VCPKG", "CANARY_", "CMAKE_"))
        }
        for key in (
            "VisualStudioVersion",
            "VCToolsVersion",
            "WindowsSDKVersion",
            "WindowsSDKLibVersion",
            "UCRTVersion",
            "VSCMD_ARG_HOST_ARCH",
            "VSCMD_ARG_TGT_ARCH",
        ):
            self.env.pop(key, None)
        self.env["VCPKG_ROOT"] = str(self.vcpkg)
        self.env["VCPKG_VISUAL_STUDIO_PATH"] = str(self.vs)
        self.git("init", "--quiet")
        self.git("config", "core.autocrlf", "false")
        self.commit_tools()

    def write(self, relative, text):
        path = self.root / relative
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_bytes(text.encode("utf-8"))
        return path

    def git(self, *args):
        subprocess.run(
            ["git", "-C", str(self.vcpkg), *args],
            check=True,
            capture_output=True,
            env=self.env,
        )

    def commit_tools(self):
        self.git("add", ".")
        self.git(
            "-c",
            "user.name=Fixture",
            "-c",
            "user.email=fixture@example.invalid",
            "-c",
            "commit.gpgsign=false",
            "commit",
            "--quiet",
            "--allow-empty",
            "-m",
            "fixture tool revision",
        )

    def resolve(self, overrides=None, expect_failure=False, source=None):
        result_path = self.binary / "result.txt"
        result_path.unlink(missing_ok=True)
        definitions = {
            "CMAKE_SOURCE_DIR": (source or self.source).as_posix(),
            "CMAKE_BINARY_DIR": self.binary.as_posix(),
            "CMAKE_HOST_SYSTEM_PROCESSOR": "x86_64",
            "CMAKE_C_COMPILER": (self.root / "compiler/c.exe").as_posix(),
            "CMAKE_CXX_COMPILER": (self.root / "compiler/cxx.exe").as_posix(),
            "CMAKE_TOOLCHAIN_FILE": (
                self.vcpkg / "scripts/buildsystems/vcpkg.cmake"
            ).as_posix(),
            "CMAKE_GENERATOR": "Ninja",
            "CANARY_SHARED_CACHE_ROOT": self.pool.as_posix(),
            "CANARY_SHARED_CACHE_VERIFIED_ROOT": self.pool.as_posix(),
            "CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED": "ON",
            "CANARY_USE_SHARED_VCPKG_INSTALLED": "ON",
            "CANARY_SHARED_CACHE_READ_ONLY": "ON",
            "CANARY_SHARED_CACHE_RESULT_FILE": result_path.as_posix(),
            "VCPKG_TARGET_TRIPLET": "x64-test",
            "VCPKG_HOST_TRIPLET": "x64-test",
            "VCPKG_INSTALL_OPTIONS": "",
        }
        definitions.update(overrides or {})
        wrapper = self.binary / "resolve.cmake"
        wrapper.write_text(
            "cmake_minimum_required(VERSION 3.19)\n"
            + "\n".join(
                f'set({key} [==[{value}]==] CACHE STRING "" FORCE)\nset({key} [==[{value}]==])'
                for key, value in definitions.items()
            )
            + f'\ninclude("{self.module.as_posix()}")\n',
            encoding="utf-8",
        )
        process = subprocess.run(
            [CMAKE, "-P", str(wrapper)],
            capture_output=True,
            text=True,
            env=self.env,
            timeout=60,
        )
        self.assertFalse(
            self.pool.exists(), "Read-only resolution created shared cache state"
        )
        if expect_failure:
            self.assertNotEqual(process.returncode, 0, process.stdout + process.stderr)
            self.assertIn("--fresh", process.stdout + process.stderr)
            return
        self.assertEqual(process.returncode, 0, process.stdout + process.stderr)
        self.assertTrue(result_path.exists(), process.stdout + process.stderr)
        result = dict(
            line.split("=", 1) for line in result_path.read_text().splitlines()
        )
        self.assertEqual(result["active"], "true")
        self.assertEqual(result["schema"], "v5")
        self.assertEqual(result["dependency-contract"], "vcpkg-inputs-v1")
        self.assertEqual(len(result["dependency-fingerprint"]), 64)
        return result

    def assert_same_pool(self, before, after):
        for key in (
            "dependency-fingerprint",
            "installed-root",
            "buildtrees-root",
            "packages-root",
        ):
            self.assertEqual(before[key], after[key], key)

    def test_helper_comment_does_not_duplicate_libraries(self):
        before = self.resolve()
        self.module.write_text(
            self.module.read_text() + "\n# diagnostic-only revision\n", encoding="utf-8"
        )
        after = self.resolve()
        self.assert_same_pool(before, after)
        self.assertNotEqual(
            before["implementation-sha256"], after["implementation-sha256"]
        )
        self.assertNotEqual(
            before["consumer-fingerprint"], after["consumer-fingerprint"]
        )

    def test_semantic_contract_cannot_be_overridden_by_caller(self):
        before = self.resolve()
        after = self.resolve(
            {"CANARY_SHARED_CACHE_DEPENDENCY_CONTRACT": "unsafe-override"}
        )
        self.assert_same_pool(before, after)

    def test_semantic_contract_change_requires_fresh(self):
        before = self.resolve()
        self.module.write_text(
            self.module.read_text().replace('"vcpkg-inputs-v1"', '"vcpkg-inputs-v2"'),
            encoding="utf-8",
        )
        self.resolve(
            {
                "CANARY_SHARED_VCPKG_MANAGED": "ON",
                "CANARY_VCPKG_CACHE_FINGERPRINT": before["dependency-fingerprint"],
            },
            expect_failure=True,
        )

    def test_consumer_change_reuses_pool_but_requires_refresh(self):
        before = self.resolve()
        options = {"CMAKE_GENERATOR": "Visual Studio 17 2022"}
        after = self.resolve(options)
        self.assert_same_pool(before, after)
        self.assertNotEqual(
            before["consumer-fingerprint"], after["consumer-fingerprint"]
        )
        self.resolve(
            {
                **options,
                "CANARY_SHARED_VCPKG_MANAGED": "ON",
                "CANARY_VCPKG_CACHE_FINGERPRINT": before["dependency-fingerprint"],
                "CANARY_VCPKG_CONSUMER_FINGERPRINT": before["consumer-fingerprint"],
            },
            expect_failure=True,
        )

    def test_msbuild_and_cmake_share_only_dependency_identity(self):
        before = self.resolve()
        after = self.resolve(
            {
                "CANARY_SHARED_CACHE_CONSUMER": "msbuild",
                "CANARY_SHARED_CACHE_CONSUMER_TOOL": (
                    self.root / "consumer-tool/MSBuild.exe"
                ).as_posix(),
                "CANARY_SHARED_CACHE_CONSUMER_CONFIGURATION": "Release",
            }
        )
        self.assert_same_pool(before, after)
        self.assertNotEqual(
            before["consumer-fingerprint"], after["consumer-fingerprint"]
        )

    def test_cleanup_options_are_consumer_only(self):
        before = self.resolve()
        for options in (
            "--clean-buildtrees-after-build",
            "--clean-packages-after-build",
            "--clean-packages-after-build;--clean-buildtrees-after-build",
        ):
            with self.subTest(options=options):
                after = self.resolve({"VCPKG_INSTALL_OPTIONS": options})
                self.assert_same_pool(before, after)
                self.assertNotEqual(
                    before["consumer-fingerprint"], after["consumer-fingerprint"]
                )

    def test_unknown_and_build_options_remain_dependency_inputs(self):
        before = self.resolve()
        for option in (
            "--head",
            "--editable",
            "--future-option",
            "--clean-packages-after-build=unexpected",
        ):
            with self.subTest(option=option):
                after = self.resolve({"VCPKG_INSTALL_OPTIONS": option})
                self.assertNotEqual(
                    before["dependency-fingerprint"], after["dependency-fingerprint"]
                )

    def test_manifest_content_and_baseline_change_identity(self):
        before = self.resolve()
        for manifest in (
            {"name": "fixture", "version-string": "1", "dependencies": ["fmt"]},
            {
                "name": "fixture",
                "version-string": "1",
                "dependencies": ["zlib"],
                "builtin-baseline": "1" * 40,
            },
        ):
            self.write("source/vcpkg.json", json.dumps(manifest))
            self.assertNotEqual(
                before["dependency-fingerprint"],
                self.resolve()["dependency-fingerprint"],
            )

    def test_manifest_line_endings_and_checkout_path_are_neutral(self):
        manifest = json.loads((self.source / "vcpkg.json").read_text())
        self.write("source/vcpkg.json", json.dumps(manifest, indent=2) + "\n")
        before = self.resolve()
        clone = self.root / "another-worktree"
        shutil.copytree(self.source, clone)
        clone.joinpath("vcpkg.json").write_bytes(
            clone.joinpath("vcpkg.json").read_bytes().replace(b"\n", b"\r\n")
        )
        self.assert_same_pool(before, self.resolve(source=clone))

    def test_features_linkage_sdk_and_toolset_remain_distinct(self):
        before = self.resolve()
        for key, value in {
            "VCPKG_MANIFEST_FEATURES": "test",
            "VCPKG_MANIFEST_NO_DEFAULT_FEATURES": "ON",
            "VCPKG_BUILD_TYPE": "debug",
            "VCPKG_CRT_LINKAGE": "static",
            "VCPKG_PLATFORM_TOOLSET_VERSION": "14.1",
        }.items():
            with self.subTest(setting=key):
                self.assertNotEqual(
                    before["dependency-fingerprint"],
                    self.resolve({key: value})["dependency-fingerprint"],
                )
        self.env["WindowsSDKVersion"] = "10.0.fixture"
        self.assertNotEqual(
            before["dependency-fingerprint"], self.resolve()["dependency-fingerprint"]
        )

    def test_compiler_and_vcpkg_executable_contents_are_inputs(self):
        before = self.resolve()
        self.write("compiler/cxx.exe", "changed compiler")
        after = self.resolve()
        self.assertNotEqual(
            before["dependency-fingerprint"], after["dependency-fingerprint"]
        )
        self.write(
            "vcpkg/vcpkg.exe" if os.name == "nt" else "vcpkg/vcpkg",
            "changed vcpkg executable",
        )
        self.assertNotEqual(
            after["dependency-fingerprint"], self.resolve()["dependency-fingerprint"]
        )

    def test_vcpkg_revision_and_toolchain_are_inputs(self):
        before = self.resolve()
        self.commit_tools()
        after = self.resolve()
        self.assertNotEqual(
            before["dependency-fingerprint"], after["dependency-fingerprint"]
        )
        self.write("vcpkg/scripts/buildsystems/vcpkg.cmake", "# different toolchain\n")
        self.commit_tools()
        self.assertNotEqual(
            after["dependency-fingerprint"], self.resolve()["dependency-fingerprint"]
        )

    def test_triplet_overlay_and_chainload_contents_are_inputs(self):
        triplet = self.write(
            "source/triplets/x64-test.cmake", "set(VCPKG_TARGET_ARCHITECTURE x64)\n"
        )
        chainload = self.write("source/toolchain.cmake", "# fixture chainload\n")
        options = {
            "VCPKG_OVERLAY_TRIPLETS": triplet.parent.as_posix(),
            "VCPKG_CHAINLOAD_TOOLCHAIN_FILE": chainload.as_posix(),
        }
        before = self.resolve(options)
        triplet.write_text(
            "set(VCPKG_TARGET_ARCHITECTURE x64)\nset(VCPKG_LIBRARY_LINKAGE static)\n",
            encoding="utf-8",
        )
        after = self.resolve(options)
        self.assertNotEqual(
            before["dependency-fingerprint"], after["dependency-fingerprint"]
        )
        chainload.write_text("# changed chainload\n", encoding="utf-8")
        self.assertNotEqual(
            after["dependency-fingerprint"],
            self.resolve(options)["dependency-fingerprint"],
        )

    def test_registry_payload_and_version_database_are_inputs(self):
        self.write(
            "source/vcpkg-configuration.json",
            json.dumps(
                {
                    "registries": [
                        {"kind": "filesystem", "path": "registry", "packages": ["zlib"]}
                    ]
                }
            ),
        )
        self.write("source/registry/ports/zlib/portfile.cmake", "# fixture port\n")
        self.write(
            "source/registry/versions/baseline.json",
            '{"default":{"zlib":{"baseline":"1","port-version":0}}}',
        )
        before = self.resolve()
        self.write(
            "source/registry/versions/baseline.json",
            '{"default":{"zlib":{"baseline":"2","port-version":0}}}',
        )
        after = self.resolve()
        self.assertNotEqual(
            before["dependency-fingerprint"], after["dependency-fingerprint"]
        )
        self.write("source/registry/ports/zlib/portfile.cmake", "# changed port\r\n")
        self.assertNotEqual(
            after["dependency-fingerprint"], self.resolve()["dependency-fingerprint"]
        )

    def test_old_managed_pool_is_not_relabelled(self):
        self.resolve(
            {
                "CANARY_SHARED_VCPKG_MANAGED": "ON",
                "CANARY_VCPKG_CACHE_FINGERPRINT": "0" * 64,
                "VCPKG_INSTALLED_DIR": (
                    self.pool / "vcpkg-installed/v4" / ("0" * 24)
                ).as_posix(),
            },
            expect_failure=True,
        )


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--module", type=Path, default=MODULE)
    args, remaining = parser.parse_known_args()
    MODULE = args.module.resolve(strict=True)
    if not CMAKE:
        parser.error(
            "cmake must be on PATH; no compiler or installed packages are needed"
        )
    unittest.main(argv=[__file__, *remaining])
