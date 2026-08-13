## Git Safety

- Before committing or pushing, always check `git status --short --branch` and `git branch -vv`.
- Never push directly to `origin/main`, including from the local `main` branch. Changes targeting `main` must go through a pull request.
- A working branch must not track `origin/main` unless the current branch is exactly `main`.
- Create new working branches under the GitHub username prefix `dudantas/`, not `codex/`, unless the user explicitly asks for another name.
- For feature/fix branches, the upstream must point to the same remote branch name, for example `dudantas/example -> origin/dudantas/example`.
- If a branch is tracking the wrong upstream, stop and fix it before committing or pushing:
  - `git branch --unset-upstream <branch>`
  - then push explicitly with `git push -u origin <branch>` only when the branch should be published.
- Prefer explicit push targets for safety: `git push origin HEAD:<branch>`.
- Never push to `origin/main` from a feature/fix branch. The repository may allow bypassing main protections, so this check is mandatory.

## Commit Policy

- Use Conventional Commit style for commit titles: `<type>(optional-scope): <summary>`.
- Prefer these commit types: `feat`, `fix`, `perf`, `refactor`, `test`, `docs`, `build`, `ci`, `chore`, and `revert`.
- Keep commit titles concise, imperative, and lowercase after the type, for example `fix: prevent inbox overflow`.
- Do not end commit titles with a period.
- Use a scope when it adds useful context, for example `fix(container): avoid stale child updates`.
- For release-only changes, use `chore: update release version to X.Y.Z`.
- Do not mix unrelated changes in the same commit unless the user explicitly asks for a single combined commit.
- Before amending or rebasing commits that may already be pushed, check the remote state and prefer `--force-with-lease` when a rewrite is explicitly approved.

## Recurring Defect Prevention

- When a confirmed defect represents a reusable failure mode rather than an isolated mistake, inspect analogous code paths before closing the change. Search by behavior and ownership pattern, not only by the original symbol or file name.
- After fixing such a defect, explicitly ask whether another contributor or generated change could recreate it elsewhere. If so, add or update a narrow prevention rule in the nearest applicable `AGENTS.md` before considering the task complete, unless code or tooling already makes that failure mode impossible.
- Back the `AGENTS.md` rule with a helper API, type constraint, static check, architecture document, or focused test when practical. Prefer enforceable safeguards; use the instruction as the repository-wide review contract.
- A reusable rule must describe the unsafe pattern, the required alternative, and the validation expected. Do not write rules that merely restate one incident, mention a specific pull request, or depend on undocumented context.
- Keep the audit proportional to the failure mode. Fix confirmed sibling occurrences in atomic commits, but do not expand an incident into a speculative repository-wide refactor or add a permanent rule for a genuinely isolated mistake.
- Treat review findings caused by common human or generated-code shortcuts as candidates for prevention, especially lifetime errors, unchecked arithmetic, stale identity, unsafe ownership transfer, missing bounds, and work that can escape its cancellation domain.

## Deferred Callback Lifetime Safety

- Treat every scheduled, deferred, asynchronous, timer, and worker-completion callback as potentially executing after its originating object or state has been destroyed, replaced, reloaded, disconnected, or moved.
- Do not capture raw `this`, references, iterators, or pointers into mutable containers when the callback can outlive the current call. Prefer immutable value captures and `std::weak_ptr` ownership; lock at execution time and return safely if ownership expired.
- Re-resolving an entity by ID is insufficient when that ID can be reused. Also validate the original object identity, generation, epoch, or session token before applying mutations.
- Operations that remove, replace, reload, or reinterpret callback-owned state must cancel pending work or advance a generation token checked by every related callback.
- Types that own scheduled callbacks must be non-movable unless moving explicitly cancels or rebinds every pending event, preserves event ownership, and has focused regression coverage.
- Use signed or checked arithmetic for countdowns and retry intervals so subtraction cannot wrap into a large delay.
- A stale callback must become a no-op before performing gameplay mutations, Lua calls, combat, movement, persistence, or client output.
- Where practical, cover destroyed owners, removed entries, reused IDs, generation mismatches, shutdown, and ownership transfer in focused tests.

## Build Policy

- Compile when the change is critical, complex, or likely to break compilation. For small documentation, script, or clearly non-build-affecting changes, avoid builds unless they add real validation value.
- When compiling, prioritize the correct known workflow below instead of guessing commands or creating new build trees, to avoid wasting time on environment or cache mistakes.
- When adding, removing, or renaming C++ source/header files, update every maintained build entry point in the same change. For Canary server code this usually means the relevant `CMakeLists.txt` file and the tracked Visual Studio project `vcproj/canary.vcxproj`; for tests, update the relevant test `CMakeLists.txt` as well. Missing `.cpp` entries in `vcproj/canary.vcxproj` commonly appear as unresolved external linker errors when building `vcproj/canary.sln`.
- Before building on Windows, inspect the repository build entry points instead of guessing:
  - Check `CMakePresets.json` and `CMakeLists.txt`.
  - Check whether Visual Studio solutions exist, such as `vcproj/*.sln` or generated `build/**/*.sln`.
  - Check whether a CMake cache already exists under `build/<preset>`.
- Prefer the CMake preset workflow over Visual Studio solution builds unless the user explicitly asks for the solution path or the preset is unusable.
- Prefer the release preset for normal local validation because it uses the intended cache and unity settings. The default Windows server build path is:

```bat
cmake --preset windows-release
cmake --build --preset windows-release --target canary
```

- On Windows, prefer running the CMake commands from the Visual Studio Developer Command Prompt or Developer PowerShell. That environment is the expected reliable build environment because it already prepares the MSVC compiler, Windows SDK, CMake tools, Ninja, and the required environment variables.
- If the shell is not already a Visual Studio developer environment, initialize it with `VsDevCmd.bat` before configuring or building. `cl.exe` and Ninja must be available in `PATH` before running CMake.
- If Ninja is not in `PATH`, use the Ninja bundled with the Visual Studio CMake tools instead of changing generators or creating another build tree.
- Treat these files/directories as signs of an active CMake/Ninja cache: `CMakeCache.txt`, `CMakeFiles/`, `build.ninja`, `.ninja_deps`, `.ninja_log`, `cmake_install.cmake`, `compile_commands.json`, `vcpkg-manifest-install.log`, and `VSInheritEnvironments.txt`.
- If CMake reports changed compiler variables, missing `CMAKE_MAKE_PROGRAM`, or an incompatible cache, remove only the affected preset directory after verifying it is inside `build/`, then rerun the same preset. Do not create ad-hoc build directories for recovery.
- Do not switch from CMake presets to a generated `.sln` just because configure failed. Fix the preset environment/cache first.

## Precompiled Header Policy

- The project uses `src/pch.hpp` for common standard/library headers.
- Do not add unguarded standard/library includes that are already provided by `src/pch.hpp`.
- If a source or header needs a PCH-provided include for builds without precompiled headers, wrap it like:

```cpp
#ifndef USE_PRECOMPILED_HEADERS
	#include <memory>
#endif
```

- If a new broadly used standard/library header is required in PCH-enabled builds, add it to `src/pch.hpp` and keep local fallback includes guarded by `#ifndef USE_PRECOMPILED_HEADERS`.

## Lua Shared Userdata Gate

- Treat Lua bindings that store `std::shared_ptr<T>` in userdata as high-risk ownership code.
- Before changing shared userdata bindings, read `docs/systems/lua-shared-userdata.md`.
- New shared userdata types must define `LuaUserdataTraits<T>::name` and use `Lua::registerSharedClass<T>`, `Lua::pushSharedUserdata<T>`, or `Lua::pushBorrowedSharedUserdata<T>`.
- Do not add new uses of `Lua::pushUserdata<T>(..., std::shared_ptr<T>)` followed by manual `Lua::setMetatable`.
- Do not use `Lua::setWeakMetatable` for userdata that stores `std::shared_ptr<T>`; it removes `__gc` and can leak the stored C++ object.
- Do not wrap borrowed objects as `std::shared_ptr<T>(&object)` without a no-op deleter. Prefer `Lua::pushBorrowedSharedUserdata<T>`.
- When reviewing or validating Lua binding changes, run these checks from the repository root and investigate every match:

```sh
rg -n "pushUserdata<.*std::shared_ptr|setWeakMetatable|std::shared_ptr<[^>]+>\\(&" src/lua
rg -n "registerSharedClass\\(L," src/lua
```

## Docker Quickstart Policy

- The Docker quickstart is intended for non-expert users to run a local Canary stack with minimal setup.
- Keep CI/build Docker, local development Docker, and user-facing quickstart Docker as separate responsibilities unless a change explicitly documents why they must overlap.
- `docker/docker-compose.yml` must keep `login-server` as the default client login webservice.
- Do not point clients to MyAAC `login.php`.
- The MyAAC quickstart image must not include or expose `login.php`; MyAAC is used only as the website/admin AAC.
- The default client login URL is `http://localhost:8088/login`.
- The default web/admin URL is `http://localhost:8080`.
- MyAAC must build from the `slawkens/myaac` `develop` branch unless a compatibility reason is documented.
- Public Docker env vars for Canary should use the `CANARY_*` prefix. Avoid adding new public `MYSQL_*`, `OT_*`, or raw Lua config variable names.
- The quickstart must not require compiling Canary locally; use the published Canary runtime image.

## PR Communication Policy

- Do not post any PR comments/reviews automatically.
- Only post PR comments/reviews when the user explicitly asks.
- All PR comments/reviews posted by me must be in English.
