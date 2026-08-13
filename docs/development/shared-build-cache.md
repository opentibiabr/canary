# Shared build cache for worktrees and forks

Related native-code repositories can share expensive reusable artifacts across Git worktrees and independent forks without sharing mutable CMake build trees. The shared pool must live on a local filesystem outside every source and build hierarchy, so removing one checkout cannot remove another checkout's dependencies.

## Cache ownership

| Layer | Ownership | Reason |
| --- | --- | --- |
| CMake and Solution outputs | One per worktree and build system | CMake/Ninja state, MSBuild intermediate directories, objects, PCH/PDB files, generated files, and executables contain consumer-specific paths. |
| vcpkg binary cache | Global | vcpkg addresses binary packages by their package ABI. Different manifests and baselines can reuse a package when its ABI is identical. |
| vcpkg downloads | Global | Sources and tools are reusable download assets. |
| `VCPKG_INSTALLED_DIR` | One per complete dependency fingerprint | Any worktree or independent fork with the same contract uses the same installed tree. Different contracts receive different trees. |
| vcpkg `buildtrees` and `packages` | One per fingerprint, transient | Compatible installs serialize on one installed-root lock. Incompatible installs cannot stage or clean each other's files. |
| sccache storage | Global per user or machine | Compiler outputs are content-addressed. Exact source roots in `SCCACHE_BASEDIRS` normalize equivalent paths across checkouts. |

MSVC precompiled headers remain worktree-local. Current sccache releases report compilations using `/Fp` or `/Yc` as non-cacheable, so `SCCACHE_BASEDIRS` benefits only eligible units and tools. Do not share `.pch` files or remove PCH flags merely to force cache hits; use `sccache --show-stats` to distinguish this expected limitation from a path-normalization regression.

Never junction, symlink, or otherwise share an entire `build` or `vcpkg_installed` directory manually. Do not place the pool inside a primary worktree.

## Windows setup

From a worktree in each independent Git repository that should participate, run:

```powershell
pwsh -File tools/configure_shared_build_cache.ps1
```

If the machine has more than one Visual Studio/MSBuild installation, select the executable that actually opens or builds the Solutions:

```powershell
pwsh -File tools/configure_shared_build_cache.ps1 -SolutionMSBuildPath <path-to-MSBuild.exe>
```

The helper persists that choice as `CANARY_SOLUTION_MSBUILD_PATH` and uses it whenever it regenerates Solution contracts. The exact MSBuild executable is a consumer input, so switching to another installation requires regenerating the `.props`; the neutral dependency fingerprint and expanded vcpkg tree can still remain identical.

The first invocation creates a machine-local repository registry below the shared cache root. Later invocations add the current repository's Git common directory. Every invocation re-enumerates all registered repositories and their worktrees, so `SCCACHE_BASEDIRS` and cache audits cover the complete set instead of replacing one fork with another.

For backward compatibility, the default shared root is a `canary-build-cache` directory beside the active `VCPKG_ROOT`. Override it with the same short, local path in every participating repository when needed:

```powershell
pwsh -File tools/configure_shared_build_cache.ps1 -CacheRoot <cache-root>
```

The helper:

- persists `CANARY_SHARED_CACHE_ROOT` for the current Windows user;
- verifies that the pool and its existing ancestors are on a ready local fixed volume without reparse points, persists `CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED=ON`, and binds that proof to the exact path in `CANARY_SHARED_CACHE_VERIFIED_ROOT`;
- registers the current independent Git repository and discovers all its worktrees;
- preserves an existing vcpkg binary-cache configuration or creates a local file backend when absent;
- never persists or prints an existing `VCPKG_BINARY_SOURCES`, because it may contain credentials;
- makes the vcpkg downloads directory explicit and global;
- does not persist or change `VCPKG_ROOT`; the active project or tool manager owns the vcpkg executable;
- pins the Visual Studio instance selected by vcpkg in the compatibility variable `CANARY_VCPKG_VISUAL_STUDIO_PATH`; the CMake module exports the standard vcpkg variable only to its configure process;
- manages `SCCACHE_BASEDIRS` as the union of every registered worktree root plus pre-existing unmanaged entries;
- creates cache directories and, when the repository carries the Solution bridge, prepares its ignored generated `.props`; it does not configure CMake or compile the project.

Restart open terminals and long-running development applications after setup. Restart an existing sccache server only after active builds finish. Run the helper after adding, moving, or removing worktrees.

Audit all registered repositories without mutation:

```powershell
pwsh -File tools/configure_shared_build_cache.ps1 -AuditOnly
```

Remove the current repository family from the machine-local registry before retiring it:

```powershell
pwsh -File tools/configure_shared_build_cache.ps1 -UnregisterCurrentRepository
```

This updates the managed sccache roots but does not delete the repository or any cache data.

Remove only the legacy transient directories below the active `VCPKG_ROOT` with:

```powershell
pwsh -File tools/configure_shared_build_cache.ps1 -CleanTransientVcpkg
```

The helper refuses cleanup while build-related processes are active and holds the vcpkg root lock during deletion. It preserves installed trees, downloads, binary packages, and fingerprint-specific pools.

To reclaim only the disposable `buildtrees` and `packages` data for one known schema-v3 pool, pass its full dependency SHA-256:

```text
pwsh -File tools/configure_shared_build_cache.ps1 -CleanSharedFingerprintTransients <full-dependency-fingerprint>
```

This narrower cleanup validates the full-hash identity metadata, confines both targets to the verified local cache root, holds the registry operation lock and that installed tree's vcpkg lock, and refuses to run while build processes are active. It never removes the expanded installed tree, metadata, downloads, or binary cache. Because it does not prune persistent data, it remains suitable when the global consumer audit is incomplete; pruning an installed fingerprint still requires the complete audit described below.

## Non-Windows setup

Set `CANARY_SHARED_CACHE_ROOT` to one short local path outside every participating checkout. After independently verifying that exact path is on a local filesystem with reliable lock and rename semantics, set `CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED=ON` and set `CANARY_SHARED_CACHE_VERIFIED_ROOT` to the same absolute path. Repeat the verification whenever the root changes. Keep downloads, the vcpkg binary cache, and sccache global. Build the `SCCACHE_BASEDIRS` list from the exact roots emitted by `git worktree list` for every independent repository, separated by `:`.

Do not use a network filesystem for mutable installed or transient pools. Its locking and rename semantics may not be strong enough for concurrent vcpkg operations.

## Normal configure and build

Continue using repository presets:

```text
cmake --preset <configure-preset>
cmake --build --preset <build-preset>
```

`cmake/SharedBuildCache.cmake` runs before the first `project()` call. When it can prove the complete installation contract, it selects:

```text
<cache-root>/vcpkg-installed/v3/<dependency-fingerprint>
<cache-root>/vcpkg-buildtrees/v3/<dependency-fingerprint>
<cache-root>/vcpkg-packages/v3/<dependency-fingerprint>
```

The first directory is persistent. The latter two are transient and are cleaned after successful dependency builds by the preset's vcpkg options.

If sharing cannot be proven, a fresh configure uses `<binary-dir>/vcpkg_installed`, `<binary-dir>/vcpkg-buildtrees`, and `<binary-dir>/vcpkg-packages`. This fallback prefers duplication over mixing incompatible binaries and cannot collide with another opt-out project.

Container and packaging stages may preprovision an immutable installed tree and configure with `VCPKG_MANIFEST_INSTALL=OFF`. In that explicit mode the module preserves the caller's `VCPKG_INSTALLED_DIR`, does not assign shared transient roots, and marks the shared pool inactive. Switching an existing managed configure tree to or from this mode still requires `--fresh`. Do not use this exception for an installation that vcpkg will mutate.

Windows Ninja presets that select `cl.exe` require a Visual Studio developer environment. `VsDevCmd.bat` may replace an existing `VCPKG_ROOT` with the vcpkg bundled by Visual Studio, so initialize the developer environment first and then select the project-managed `VCPKG_ROOT` before running the helper, configure, or build in that same environment. A different vcpkg installation is a different dependency contract and may intentionally select a different pool or trigger the safe local fallback. On other hosts, set both `CC` and `CXX`, or both CMake compiler variables, when the first configure cannot identify them safely.

Disable the shared installed tree for an isolated configure with:

```text
-DCANARY_USE_SHARED_VCPKG_INSTALLED=OFF
```

Switching an existing build tree between opt-in and opt-out changes dependency paths and therefore requires:

```text
cmake --fresh --preset <configure-preset> -DCANARY_USE_SHARED_VCPKG_INSTALLED=OFF
```

Use separate configure presets and binary directories if opt-in and opt-out builds must exist simultaneously.

## Visual Studio Solution builds

Repositories that include `SharedVcpkgCache.targets` in their maintained Solution directory use the same dependency resolver for CMake and MSBuild. Normal setup generates an ignored, machine-local `.canary-shared-cache/SharedVcpkgCache.props` beside the selected project. Regenerate it directly when only the Solution contract changed:

```powershell
pwsh -File tools/configure_shared_solution_cache.ps1
```

Projects whose Solution uses configuration names other than the conventional
`Debug` and `Release` can generate all contracts explicitly, for example:

```powershell
pwsh -File tools/configure_shared_solution_cache.ps1 -Configurations Debug,OpenGL,DirectX
```

The setup and audit helper discovers the maintained x64 project in the common
`vcproj`, `vc18`, or `vc17` layout and derives its configuration names from the
project file. This keeps repositories with a CMake entry point and a native
Solution under the same dependency contract without sharing their object,
PCH, PDB, generated-source, or output directories.

Reload the Visual Studio project after the file changes. The generated file supplies each supported configuration with its validated `VcpkgInstalledDir`, fingerprint-specific `buildtrees` and `packages` roots, cleanup options, selected vcpkg checkout, and pinned Visual Studio instance. The tracked target re-evaluates the complete contract immediately before `VcpkgInstallManifestDependencies` inside the active developer environment; stale generated values stop the build and request regeneration instead of mutating the wrong pool.

The bridge uses two hashes:

- the **dependency fingerprint** is neutral between CMake and MSBuild and owns the expanded installed and transient roots;
- the **consumer fingerprint** binds that dependency contract to the invoking build system, generator or configuration, and its build-system tool.

Consequently, a Solution Release configuration and a CMake Release preset share one expanded tree only when their target and host triplets, features, registries, overlays, linkage, compiler, toolset, SDK, vcpkg revision, and dependency tools all match. Debug or any other configuration with a different contract receives another dependency fingerprint automatically. Command-line MSBuild overrides for the manifest root, triplets, link configuration, toolset, SDK, or install options are compared with the generated contract and fail closed when incompatible. Never copy a fingerprint from another configuration or edit the generated `.props`.

When no generated `.props` exists, the Solution uses `vcpkg_installed`, `.vcpkg-buildtrees/<configuration>`, and `.vcpkg-packages/<configuration>` below its own project directory. This is the safe fallback when the global cache is not configured. Solution objects, PCH/PDB files, generated protocol sources, intermediate directories, and executables always remain local, even when dependencies converge with CMake.

Audit only the Solution bridge without writing pools or generated files:

```powershell
pwsh -File tools/configure_shared_solution_cache.ps1 -AuditOnly
```

Use `-WhatIf` to preview the contracts. The repository-wide `configure_shared_build_cache.ps1 -AuditOnly` also scans and re-evaluates generated Solution contracts across every registered worktree. The Solution inherits the global vcpkg downloads and binary cache. It does not automatically route compiler invocations through sccache; adding such a launcher is a separate concern, and MSVC PCH compilations remain ineligible.

## Sharing across baselines and forks

The repository name, branch, and absolute checkout path are not fingerprint inputs. Independent forks therefore converge when their declared and effective dependency contracts are identical.

A common `builtin-baseline` improves the chance of reuse but is not sufficient. Sharing an installed tree also requires identical manifests, enabled features, registry configuration and content, ordered overlays, target and host triplets, linkage, vcpkg options, compiler/toolset identity, dependency-tool identity, and vcpkg revision.

Repositories in one maintained fork family must inherit their vcpkg baseline, default registry baseline, version metadata, and shared custom-port payloads from that family's open upstream. A fork may add a dependency required by its own code, but it must resolve common dependencies through the same catalog instead of selecting an independent version. Scheduled update automation must synchronize from the open upstream rather than advancing each fork independently.

An unrelated project family or a temporarily incompatible migration may still use a different catalog. The fingerprint isolates that contract while downloads and ABI-compatible binary packages remain global. Treat such a split as an explicit compatibility boundary, not as a disk-saving shortcut, and document why the canonical catalog cannot yet be used.

One fixed global vcpkg tool checkout may serve several manifest baselines when that is the repository's supported workflow. If projects require different vcpkg tool revisions, activate an immutable tool root per revision or per shell. Never let concurrent projects switch one shared mutable vcpkg checkout between revisions. The selected executable, toolchain, and Git revision participate in the fingerprint.

vcpkg does not provide a supported content-addressed or hardlinked representation for files expanded into different installed trees. The safe native limit is one expanded tree per exact contract; do not hardlink or junction two distinct fingerprints.

### Canonical dependency contracts between forks

The fingerprint deliberately does not guess that two different vcpkg declarations are semantically equivalent. For example, a byte-identical custom port delivered as an overlay and as a filesystem registry still produces different fingerprints. Those mechanisms have different precedence, version selection, and metadata rules, so automatically treating them as interchangeable could mix incompatible installations.

When several maintained forks are intended to use the same dependency contract, select one canonical representation and port that representation atomically. A versioned filesystem registry is usually preferable for a maintained custom port because it records both the port payload and its version metadata. Equality requires more than copying the port directory:

- keep `vcpkg.json`, the separate or embedded vcpkg configuration, registry metadata, triplets, features, and install options aligned;
- include the filesystem registry's `versions/baseline.json` and per-port version database, not only `ports/<port>`;
- keep the same normalized `cmake/SharedBuildCache.cmake` implementation and schema;
- use the same vcpkg tool revision and compiler contract for configurations that are expected to converge;
- when automation updates a baseline that is declared in both the manifest and `default-registry`, update both declarations in one change.

Before canonicalizing two forks, compare the dependency inputs and prove that the selected features, linkage, target and host triplets, and custom port contents are compatible. Align common dependency versions to the open upstream catalog. Preserve only genuinely additive dependencies and build-contract differences; they receive a separate fingerprint while still sharing downloads, sccache storage, and ABI-compatible binary packages.

After adopting the canonical representation, run the setup helper from the newly participating repository, configure its existing preset with `--fresh`, regenerate any Solution `.props`, and compare the full dependency fingerprints. Matching fingerprints are the result of matching contracts; never override or manually rename a fingerprint to force convergence. If the fingerprints differ, inspect their metadata and preserve the separate pools until the remaining input difference is understood.

Another build system must keep its expanded installed tree local until it consumes this same neutral dependency contract, validates its own consumer fingerprint, and supplies equivalent locking and transient-root options. It may still use the global downloads and vcpkg binary cache.

## Fingerprint contract

The dependency fingerprint contains inputs that can change the manifest installation or package ABI:

- the normalized implementation hash and schema of `cmake/SharedBuildCache.cmake`;
- the complete `vcpkg.json`, including either supported embedded configuration spelling, and optional separate `vcpkg-configuration.json`;
- contents of filesystem registries declared by the configuration;
- ordered contents of overlay port and overlay triplet directories declared by variables or configuration;
- target and host triplet names and selected triplet files;
- manifest features, feature flags, linkage settings, build type, and install options;
- chainloaded toolchain contents;
- host identity and the CMake executable/version used as a dependency tool;
- C and C++ compiler executable hashes;
- on Windows, the pinned vcpkg Visual Studio instance, `vcvarsall.bat`, and selectable MSVC compiler tool binaries;
- selected Visual Studio toolset, Windows SDK, and host/target architecture environment;
- vcpkg executable, toolchain, repository revision, and relevant dirty state.

The consumer fingerprint includes the dependency fingerprint and then adds either the CMake generator and CMake consumer identity, or the MSBuild executable, build configuration, link configuration, platform, toolset, and SDK. Consumer-specific values do not create duplicate installed trees when the dependency contract is identical, but they are validated to prevent a stale CMake cache or generated `.props` from silently changing build systems.

The module disables sharing when any required identity or the local-filesystem guarantee is ambiguous. Absolute worktree paths do not participate. Content paths inside manifests and configurations still participate through the files themselves, while referenced local trees are hashed using relative file names and contents.

The module's normalized SHA-256 is part of schema `v3`. Copies in different forks must therefore be byte-equivalent after newline normalization to converge. A divergent implementation selects another fingerprint even if a maintainer forgets to bump the schema.

An existing configured preset never changes fingerprint or falls back in place. Cached package variables could retain paths into the old pool, so the module stops before `project()` and requests `cmake --fresh --preset <configure-preset>`.

Fingerprint input files and trees are CMake configure dependencies. Adding, removing, or changing a manifest, registry, overlay, triplet, compiler, or toolchain input requests regeneration.

The full dependency SHA-256 and non-local metadata are written below `<cache-root>/metadata/v3`. Directory names use the first 24 hexadecimal characters to limit Windows path length; the metadata lock verifies the full hash before a shortened directory is accepted.

## Concurrency

Consumers of one fingerprint request one package set and installed-root lock. Different fingerprints receive independent installed, `buildtrees`, and `packages` roots. Projects that opt out receive build-local roots.

Do not manually modify a fingerprint directory. Do not prune caches while CMake, vcpkg, Ninja, a compiler, or a linker is using any registered build family.

## Migrating existing build trees

Reconfigure an existing preset with `--fresh`; do not create an ad-hoc build directory:

```text
cmake --fresh --preset <configure-preset>
```

Verify its `CMakeCache.txt`:

```text
CANARY_SHARED_VCPKG_ACTIVE:INTERNAL=true
CANARY_VCPKG_DEPENDENCY_FINGERPRINT:INTERNAL=<full-dependency-fingerprint>
CANARY_VCPKG_CONSUMER_FINGERPRINT:INTERNAL=<full-consumer-fingerprint>
VCPKG_INSTALLED_DIR:PATH=<cache-root>/vcpkg-installed/v3/<dependency-fingerprint>
```

Also confirm that `CMakeCache.txt` and `build.ninja` contain neither a legacy local installed path nor another global fingerprint. Complete a build against the refreshed preset before deleting the old local tree, then build again after deletion. The final invocation must not recreate the local installation.

For a Solution migration, generate the `.props`, reload the project, build every migrated configuration successfully, and confirm a no-op rebuild. Only then remove that worktree's exact legacy `vcpkg_installed` directory and repeat the build. If multiple configurations used the same local installed directory, all of them must be migrated and validated before deletion.

## Cleanup and recovery

Before pruning a fingerprint:

1. Confirm no configure or build process is active.
2. Run the audit from any registered repository.
3. Inspect every reported `CMakeCache.txt`, generated Ninja file, and generated Solution contract.
4. Preserve every installed root referenced by any registered CMake or MSBuild consumer.
5. Remove only an unreferenced fingerprint and its matching transient and metadata entries.

An audit that reports an unregistered, unavailable, partially enumerated, or malformed repository/configure tree, a non-local/reparse root, or a missing/mismatched full-hash identity is incomplete and exits with failure. Do not prune any global fingerprint until every registered family is available and the audit succeeds.

Schema migrations intentionally create a new pool. Keep the previous schema until every registered configured build has migrated, built successfully, and stopped referencing it.

If one fingerprint becomes corrupt, stop all its consumers, remove only that exact directory, and reconfigure one existing preset. vcpkg recreates it from the binary cache. Do not delete downloads or the global binary cache during normal recovery.

## CI and production boundaries

The feature is opt-in through `CANARY_SHARED_CACHE_ROOT`. CI and fresh clones retain build-local manifest installations unless their environment explicitly enables the pool. Cache setup must not change deployment directories, runtime data, production services, or release publication behavior.

## Regression checklist

Before changing build or dependency configuration, verify:

- `build/<preset>` remains local to each worktree;
- Solution intermediate/output directories, PCH/PDB files, and generated files remain local;
- all vcpkg settings are finalized before `project()`;
- new manifest, registry, overlay, triplet, compiler, and toolchain inputs participate in the fingerprint;
- independent forks use the same module implementation before sharing a fingerprint;
- opt-out and fallback transients remain build-local;
- no machine-local path appears in committed presets or documentation;
- shared mutable state remains on a local filesystem outside every checkout;
- the repository registry and cleanup audit cover every consumer before data is removed.
