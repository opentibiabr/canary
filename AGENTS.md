# Canary Fork Agent Instructions

## Repository Allowlist — Highest Priority

- The only repository where write operations are allowed is `blakinio/canary`.
- Treat `opentibiabr/canary` as read-only upstream.
- Never create, update, reopen, close, comment on, label, review, or merge a pull request in `opentibiabr/canary`.
- Never create issues, branches, tags, releases, commits, or workflow changes in `opentibiabr/canary`.
- Never perform any GitHub mutation in another repository unless the user explicitly names that repository and confirms the operation in the same conversation.
- Before every GitHub write operation, verify that `repository_full_name` is exactly `blakinio/canary`.
- If the target repository differs, stop before the write and report a repository safety violation.
- A pull request is valid only when both its base repository and head repository are `blakinio/canary`.
- Do not use GitHub's fork `Contribute` flow when it targets upstream.

## Pull Request Safety

- Never push directly to `main`.
- Use a dedicated branch for every task. Prefer branch names under `ai/`, `feat/`, `fix/`, `docs/`, or `chore/`.
- Pull requests must target `blakinio/canary:main`.
- Create pull requests as drafts unless the user explicitly requests otherwise.
- Never merge a pull request automatically unless the user explicitly requests the merge after reviewing the target repository and changed files.
- Before creating a pull request, perform and report this preflight:
  - target repository: `blakinio/canary`
  - base branch: `main`
  - head repository: `blakinio/canary`
  - head branch: current working branch
  - upstream target: `NO`
- After creating a pull request, verify its URL begins with `https://github.com/blakinio/canary/pull/`.
- If a pull request URL points to any other repository, close it immediately and report the mistake.

## AI Content Project Safety

- The AI tooling lives under `tools/ai-agent/**` and `docs/ai-agent/**` unless a task explicitly requires another location.
- Keep generated content in `artifacts/**` or another explicitly approved temporary output directory.
- Do not write generated previews directly into an active datapack.
- Do not modify `.otbm` files.
- Do not modify `items.otb`.
- Do not create or replace binary map assets.
- Do not change production server configuration unless explicitly requested.
- Content generation must default to `dry-run` and produce a reviewable plan or diff.
- Any future map-writing feature must remain disabled until format detection, backup, round-trip validation, and bounded-area checks are implemented.
- New AI-agent tools must be deterministic where practical and must include unit tests.
- Prefer Python 3.12 standard-library implementations unless a dependency is clearly justified.
- Do not weaken or remove existing tests merely to make CI pass.

## Data and Identifier Safety

- Distinguish identifier definitions from references. Reuse is not automatically a conflict when it is only a reference.
- Before proposing storage, action ID, unique ID, or item ID ranges, inspect the generated registry and active reservations.
- Never overwrite an active reservation silently.
- Item IDs that require `items.xml` or `items.otb` changes must be reported as manual integration work unless explicitly approved.
- Missing monsters, NPCs, items, spells, or event registrations must be surfaced as warnings or blockers rather than silently invented.

## Change Scope and Validation

- Inspect existing Canary conventions before generating Lua, XML, C++, workflow, or configuration changes.
- Keep changes limited to the user-requested scope.
- Do not perform unrelated cleanup or broad refactors without explicit approval.
- Review `git diff --stat` and the full changed-file list before opening a pull request.
- Explicitly confirm that no forbidden paths were changed:
  - `**/*.otbm`
  - `**/items.otb`
  - active datapack content unless requested
  - production secrets or credentials
- Run relevant tests before opening a pull request and report commands and outcomes honestly.
- Do not claim that CI passed unless the corresponding workflow result was verified.

## Secrets and Sensitive Data

- Never commit tokens, passwords, private keys, connection strings, cookies, or personal data.
- Treat `.env`, secret configuration, database dumps, backups, and private logs as sensitive.
- If sensitive data is discovered, stop and report it without reproducing the secret in output or comments.
- Do not post repository comments or reviews containing local paths, credentials, internal URLs, or private diagnostic data.

## Git Safety

- Before committing or pushing, always check `git status --short --branch` and `git branch -vv`.
- Never push directly to `origin/main`, including from the local `main` branch. Changes targeting `main` must go through a pull request.
- A working branch must not track `origin/main` unless the current branch is exactly `main`.
- Create new working branches using a task-appropriate prefix such as `ai/`, `feat/`, `fix/`, `docs/`, or `chore/`.
- For feature/fix branches, the upstream must point to the same remote branch name.
- If a branch is tracking the wrong upstream, stop and fix it before committing or pushing:
  - `git branch --unset-upstream <branch>`
  - then push explicitly with `git push -u origin <branch>` only when the branch should be published.
- Prefer explicit push targets for safety: `git push origin HEAD:<branch>`.
- Never push to `origin/main` from a feature/fix branch. The repository may allow bypassing main protections, so this check is mandatory.
- Treat the `upstream` remote as fetch-only. Never push to it.

## Commit Policy

- Use Conventional Commit style for commit titles: `<type>(optional-scope): <summary>`.
- Prefer these commit types: `feat`, `fix`, `perf`, `refactor`, `test`, `docs`, `build`, `ci`, `chore`, and `revert`.
- Keep commit titles concise, imperative, and lowercase after the type, for example `fix: prevent inbox overflow`.
- Do not end commit titles with a period.
- Use a scope when it adds useful context, for example `fix(container): avoid stale child updates`.
- For release-only changes, use `chore: update release version to X.Y.Z`.
- Do not mix unrelated changes in the same commit unless the user explicitly asks for a single combined commit.
- Before amending or rebasing commits that may already be pushed, check the remote state and prefer `--force-with-lease` when a rewrite is explicitly approved.

## Build Policy

- Compile when the change is critical, complex, or likely to break compilation. For small documentation, script, or clearly non-build-affecting changes, avoid builds unless they add real validation value.
- When compiling, prioritize the correct known workflow below instead of guessing commands or creating new build trees, to avoid wasting time on environment or cache mistakes.
- When adding, removing, or renaming C++ source/header files, update every maintained build entry point in the same change. For Canary server code this usually means the relevant `CMakeLists.txt` file and the tracked Visual Studio project `vcproj/canary.vcxproj`; for tests, update the relevant test `CMakeLists.txt` as well.
- Before building on Windows, inspect the repository build entry points instead of guessing:
  - Check `CMakePresets.json` and `CMakeLists.txt`.
  - Check whether Visual Studio solutions exist, such as `vcproj/*.sln` or generated `build/**/*.sln`.
  - Check whether a CMake cache already exists under `build/<preset>`.
- Prefer the CMake preset workflow over Visual Studio solution builds unless the user explicitly asks for the solution path or the preset is unusable.
- Prefer the release preset for normal local validation:

```bat
cmake --preset windows-release
cmake --build --preset windows-release --target canary
```

- On Windows, prefer running the CMake commands from the Visual Studio Developer Command Prompt or Developer PowerShell.
- If the shell is not already a Visual Studio developer environment, initialize it with `VsDevCmd.bat` before configuring or building.
- If Ninja is not in `PATH`, use the Ninja bundled with the Visual Studio CMake tools instead of changing generators or creating another build tree.
- Treat `CMakeCache.txt`, `CMakeFiles/`, `build.ninja`, `.ninja_deps`, `.ninja_log`, `cmake_install.cmake`, `compile_commands.json`, `vcpkg-manifest-install.log`, and `VSInheritEnvironments.txt` as signs of an active CMake/Ninja cache.
- If CMake reports changed compiler variables, missing `CMAKE_MAKE_PROGRAM`, or an incompatible cache, remove only the affected preset directory after verifying it is inside `build/`, then rerun the same preset.
- Do not switch from CMake presets to a generated `.sln` merely because configure failed. Fix the preset environment/cache first.

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
- When reviewing or validating Lua binding changes, run these checks and investigate every match:

```sh
rg -n "pushUserdata<.*std::shared_ptr|setWeakMetatable|std::shared_ptr<[^>]+>\(&" src/lua
rg -n "registerSharedClass\(L," src/lua
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

- Do not post PR comments or reviews automatically.
- Only post PR comments or reviews when the user explicitly asks.
- All PR comments and reviews must be in English.
