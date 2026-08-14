# Canary-specific guidance

The global Git, commit, PR, C++ header, exception, and documentation policies apply. This file only records Canary-specific gates.

## Recurring Defect Prevention

- For a reusable defect, inspect analogous paths by behavior and ownership, fix confirmed siblings atomically, and keep the audit proportional; do not turn a one-off into a speculative refactor.
- Decide whether tooling makes recurrence impossible. If not, add a narrow rule to the nearest `AGENTS.md` that states the unsafe pattern, required alternative, and validation rather than incident history.
- Prefer enforceable safeguards—types, helpers, static checks, architecture docs, or focused tests—especially for lifetime, arithmetic, identity, ownership, bounds, and cancellation escapes.

## Deferred Callback Lifetime Safety

- Assume scheduled, deferred, timer, and worker callbacks can outlive their source object or state.
- Never capture raw `this`, references, iterators, or mutable-container pointers across that boundary. Use immutable values plus `std::weak_ptr` or re-resolvable identity validated with the original identity, generation, epoch, or session token.
- Removal, replacement, reload, or reinterpretation must cancel pending work or advance a checked generation. Callback-owning types are non-movable unless moving cancels or safely rebinds every event.
- Use bounded arithmetic for intervals; stale work must become a no-op before gameplay, Lua, combat, movement, persistence, or client output. Cover destroyed/replaced owners, reused IDs, shutdown, and ownership transfer where practical.

## Canary build discipline

- When a Canary build is authorized, inspect `CMakePresets.json`, `CMakeLists.txt`, any maintained solution, and the existing preset cache. Reuse the canonical preset/cache; do not create an ad-hoc tree or switch to a solution because configuration failed.
- C++ source/header additions, removals, and renames must update every maintained entry: the relevant CMake list, server `vcproj/canary.vcxproj`, and test CMake list when applicable. Prefer `windows-release` for normal Windows CMake validation unless the task explicitly targets the solution.
- Use the compatible Visual Studio developer or owning IDE environment and its Ninja. Recreate only a verified incompatible preset directory inside `build/`; never broad-clean caches.

### MSVC Ninja dependency tracking

- Configure and build an existing preset under the same code page and environment. When uncertain, compare `rules.ninja`'s `msvc_deps_prefix` with raw `cl.exe /showIncludes`; compiler launchers stay disabled for MSVC Ninja builds.
- Treat malformed or empty `.ninja_deps` as an environment/cache state: stop concurrent builds, reconfigure, force-rebuild the affected output, then inspect `ninja -t deps <object>`. `ninja -t recompact` only compacts existing records; it cannot recreate missing dependencies.

## Precompiled Header Policy

- `src/pch.hpp` owns broad shared standard includes; do not duplicate an unguarded PCH include.
- Headers must declare their public dependencies. When a source needs a PCH-provided include without PCH, guard it with `#ifndef USE_PRECOMPILED_HEADERS`; add broad includes to the PCH with the same local fallback.

## Lua Shared Userdata Gate

- Before changing `std::shared_ptr` Lua userdata, read `docs/systems/lua-shared-userdata.md` and use its typed trait, registration, and push helpers.
- Never combine shared `pushUserdata` with a manual metatable, use a weak metatable for shared userdata, or wrap a borrowed object without a no-op deleter. Run the document's two `rg` checks and investigate every match.

## Docker Quickstart Policy

- For quickstart changes, read `docs/docker/quickstart-for-beginners.md` and `docker/DOCKER.md`; keep CI/build, development, and user quickstart responsibilities separate.
- The default client path is `login-server` at `http://localhost:8088/login`, never MyAAC `login.php`. MyAAC remains website/admin-only, uses `slawkens/myaac` `develop`, and keeps `http://localhost:8080`; public config stays `CANARY_*`, and the quickstart uses the published Canary runtime image.
