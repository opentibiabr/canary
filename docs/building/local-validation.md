# Local build validation

Use this workflow only after the active `AGENTS.md` build policy authorizes a
build. Documentation-only, script-only, and other clearly non-build-affecting
changes do not require compilation.

## Maintained build entry points

When adding, removing, or renaming C++ source or header files, update every
maintained build entry point in the same change:

- the relevant `CMakeLists.txt`;
- `vcproj/canary.vcxproj`;
- the relevant test `CMakeLists.txt`, when tests are affected.

A missing `.cpp` entry in `vcproj/canary.vcxproj` commonly appears as an
unresolved external symbol when building `vcproj/canary.sln`.

## Windows preflight

Before configuring or building:

1. Inspect `CMakePresets.json` and `CMakeLists.txt`.
2. Check for maintained Visual Studio solutions such as `vcproj/*.sln` and
   generated `build/**/*.sln`.
3. Check whether the intended preset already has a cache under
   `build/<preset>`.
4. Reuse that maintained build state. Do not guess commands or create an
   alternate build tree.

Run CMake from a Visual Studio Developer Command Prompt or Developer
PowerShell. If the current shell is not a developer environment, initialize it
with `VsDevCmd.bat`. Confirm that `cl.exe` and Ninja are available in
`PATH`. If Ninja is missing, use the copy bundled with Visual Studio's CMake
tools instead of changing generators or creating another build tree.

## Preset workflow

Prefer the CMake preset workflow over a Visual Studio solution unless the user
explicitly requests the solution or the preset is unusable. For normal local
validation, prefer the release preset because it uses the intended cache and
unity settings:

```bat
cmake --preset windows-release
cmake --build --preset windows-release --target canary
```

## Cache recovery

The following files and directories identify an active CMake/Ninja cache:

- `CMakeCache.txt`
- `CMakeFiles/`
- `build.ninja`
- `.ninja_deps`
- `.ninja_log`
- `cmake_install.cmake`
- `compile_commands.json`
- `vcpkg-manifest-install.log`
- `VSInheritEnvironments.txt`

If CMake reports changed compiler variables, a missing
`CMAKE_MAKE_PROGRAM`, or an incompatible cache, first verify the affected
preset directory is inside `build/`. Remove only that preset directory, then
rerun the same preset. Do not switch to a generated solution merely because
configuration failed; repair the preset environment or cache first.
