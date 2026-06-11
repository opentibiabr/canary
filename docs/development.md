# Development Guide

## Introduction

This document describes the development workflow used by Canary and serves as a reference for contributors who want to:

* Build the server locally
* Develop new features
* Fix bugs
* Create Lua systems
* Write tests
* Submit pull requests

Canary is an MMORPG server emulator written primarily in:

* **C++20** (server core)
* **Lua** (gameplay systems)
* **SQL** (database schema)
* **CMake** (build system)

---

# Development Philosophy

Canary follows a few important principles:

1. Keep the core engine stable.
2. Prefer gameplay customization through Lua.
3. Maintain compatibility with existing datapacks whenever possible.
4. Favor readability over clever implementations.
5. Keep systems modular and testable.
6. Avoid introducing unnecessary dependencies.

---

# Development Environment

## Recommended Tools

### IDEs

Supported:

* Visual Studio 2026
* CLion
* VSCode

### Useful Extensions

VSCode:

* C/C++
* CMake Tools

---

# Repository Structure

```text
canary/
│
├── src/
├── data/
├── data-canary/
├── data-otservbr-global/
├── docs/
├── tests/
├── docker/
├── metrics/
│
├── schema.sql
├── config.lua.dist
├── CMakeLists.txt
├── CMakePresets.json
├── vcpkg.json
└── package.json
```

---

# Development Setup

## Option 1: Docker (Recommended for Beginners)

The fastest way to start local testing is using the Docker quickstart.

Services provided:

* Canary
* MariaDB
* MyAAC
* Login Server

Start the stack:

```bash
cd docker
cp .env.dist .env
docker compose up -d --build
```

This pulls the published Canary runtime image and builds the MyAAC quickstart
image. It does not compile Canary locally.

Default endpoints:

```text
Website:                 http://localhost:8080
Client login API:        http://localhost:8088/login
Canary login protocol:   7171
Canary game protocol:    7172
Canary status protocol:  7173
Login-server gRPC:       9090
```

Docker is ideal when:

* Testing scripts
* Developing datapacks
* Learning the project structure
* Avoiding local dependency installation
* Running local or LAN demos with trusted defaults

Do not expose the quickstart directly to the public Internet with default
accounts, passwords or rolling image tags. See `docker/DOCKER.md` for the full
Docker quickstart contract.

---

# Option 2: Native Development

Recommended for engine contributors.

## Required Software

### Linux

```bash
git
gcc/g++
cmake
ninja
vcpkg
```

### Windows

```text
Visual Studio
Desktop Development with C++
Git
vcpkg
```

Canary uses **vcpkg** as its dependency manager and **CMake** as the build system.

---

# Cloning the Repository

```bash
git clone https://github.com/opentibiabr/canary.git
cd canary
```

Canary does not require Git submodules for the normal development workflow.
Configure vcpkg separately and make sure `VCPKG_ROOT` points to that vcpkg
installation before using CMake presets.

---

# Configuration

Create your local configuration:

```bash
cp config.lua.dist config.lua
```

Important settings:

```lua
serverName = "Development Server"
ip = "127.0.0.1"
mysqlHost = "localhost"
mysqlUser = "root"
mysqlPass = "password"
```

Never commit personal configuration changes.

---

# Build System

## CMake Presets

Canary provides predefined presets.

Examples:

```bash
cmake --preset linux-debug
cmake --preset linux-release
cmake --preset windows-debug
cmake --preset windows-release
```

Advantages:

* Consistent builds
* Standard compiler flags
* Shared developer experience

---

# Building Canary

## Linux

```bash
cmake --preset linux-release -DTOGGLE_BIN_FOLDER=ON
cmake --build --preset linux-release -j4
```

## Windows

Open the repository in Visual Studio.

Visual Studio can automatically:

* Detect CMake
* Resolve dependencies through vcpkg
* Generate the build cache

Make sure `VCPKG_ROOT` is configured before opening the folder or configuring
the CMake preset.

Then:

```text
Build → Build All
```

---

# Dependency Management

Canary uses:

```text
vcpkg.json
```

to declare dependencies.

Examples:

* asio
* curl
* libmariadb
* LuaJIT
* mbedtls
* protobuf
* pugixml
* spdlog

If dependencies fail:

```bash
cd "$VCPKG_ROOT"
git pull
./bootstrap-vcpkg.sh
```

or on Windows:

```powershell
Set-Location $env:VCPKG_ROOT
git pull
.\bootstrap-vcpkg.bat
```

---

# Running the Server

After compilation:

```bash
./canary
```

Expected startup sequence:

```text
Loading config
Loading map
Loading monsters
Loading NPCs
Loading scripts
Starting game server
```

---

# Database Development

Database schema:

```text
schema.sql
```

Import:

```bash
mysql -u root -p database_name < schema.sql
```

Main tables:

```text
accounts
players
guilds
houses
market
player_storage
```

Schema modifications should:

* Be backward compatible when possible
* Include migration documentation
* Avoid destructive changes

---

# Lua Development

Most gameplay features belong in Lua.

Examples:

* Quests
* NPCs
* Actions
* Talkactions
* Spells
* Events

Typical locations:

```text
data/scripts/
data/actions/
data/spells/
data/npc/
```

---

# Lua API

The server exposes C++ functionality through Lua bindings.

Examples:

```lua
player:addExperience(1000)

player:addItem(2160)

Game.getPlayers()
```

Generated API documentation is available in:

```text
docs/lua-api/
```

Enable generation:

```lua
generateLuaApiDocs = true
```

---

# Adding New Features

## Prefer Lua First

Before modifying C++:

Ask:

```text
Can this be implemented entirely in Lua?
```

If yes:

Use Lua.

If no:

Extend the C++ engine.

---

# Adding a New Lua Event

Example:

```lua
local event = CreatureEvent("Example")

function event.onLogin(player)
    player:sendTextMessage(MESSAGE_STATUS, "Welcome!")
    return true
end

event:register()
```

---

# C++ Development

## Source Layout

```text
src/
├── game/
├── creatures/
├── map/
├── items/
├── io/
├── lua/
├── server/
├── utils/
└── lib/
```

Before creating new modules:

* Check existing systems.
* Extend existing classes when appropriate.
* Avoid duplicate functionality.

---

# Coding Standards

## Naming

Classes:

```cpp
Player
Monster
ProtocolGame
```

Methods:

```cpp
addExperience()
getHealth()
sendTextMessage()
```

Variables:

```cpp
playerLevel
damageAmount
targetPosition
```

Constants:

```cpp
MAX_PLAYERS
MAX_CONTAINER_ITEMS
```

---

# General Guidelines

Prefer:

```cpp
const auto&
```

instead of unnecessary copies.

Prefer:

```cpp
std::vector
std::unordered_map
std::shared_ptr
```

when they match the ownership model of the surrounding code.

Avoid:

```cpp
new
delete
```

when smart pointers are possible.

For Lua bindings that expose shared C++ objects, read
`docs/systems/lua-shared-userdata.md` before changing ownership or userdata
registration code.

---

# Logging

Use existing logging systems.

Good:

```cpp
g_logger().info("Player {} logged in", playerName);
```

Bad:

```cpp
std::cout << "debug" << std::endl;
```

Never commit debugging output.

---

# Debugging

## Linux

Run with GDB:

```bash
gdb ./canary
```

Helper script:

```bash
./start_gdb.sh
```

---

## Common Debug Targets

Investigate:

* Crashes
* Memory corruption
* Infinite loops
* Scheduler deadlocks

Useful commands:

```gdb
bt
frame
print
continue
```

---

# Testing

Canary includes automated tests.

Build tests:

```bash
cmake --preset linux-debug

cmake --build --preset linux-debug
```

Run tests:

```bash
ctest --preset linux-debug
```

Tests should be added for:

* New systems
* Bug fixes
* Edge cases
* Regression prevention

---

# Pull Request Workflow

## Create a Branch

```bash
git checkout -b feature/new-system
```

Examples:

```text
feature/
fix/
refactor/
docs/
```

---

# Commit Messages

Good:

```text
fix(player): prevent logout race condition

feat(wheel): add progression API

refactor(combat): simplify condition processing
```

Avoid:

```text
fix stuff

update

changes
```

---

# Before Opening a Pull Request

Checklist:

* Builds successfully
* Tests pass
* No debug code
* No merge conflicts
* Documentation updated
* Lua scripts validated

---

# Reviewing Changes

When reviewing code:

Focus on:

* Correctness
* Performance
* Security
* Maintainability
* Backward compatibility

Do not approve changes solely because they work locally.

---

# Performance Considerations

Critical systems:

* Pathfinding
* Combat
* Scheduler
* Dispatcher
* Networking

Before introducing changes:

Consider:

```text
How does this behave with 1000 players?
```

Small inefficiencies become large server costs.

---

# Common Development Tasks

## Add a Spell

```text
data/spells/
```

## Add a Monster

```text
data/monster/
```

## Add an NPC

```text
data/npc/
```

## Add a Quest

```text
data/scripts/
```

## Add Engine Functionality

```text
src/
```

and expose it through:

```text
src/lua/
```

if Lua access is required.

---

# Troubleshooting

## Dependency Errors

Rebuild vcpkg:

```bash
cd "$VCPKG_ROOT"
git pull
./bootstrap-vcpkg.sh
```

---

## CMake Cache Issues

Remove only the affected preset directory, then reconfigure the same preset:

```bash
rm -rf build/<preset-name>
cmake --preset <preset-name>
```

For example, if `linux-release` is the broken cache, remove
`build/linux-release`, not the entire `build/` directory.

---

## Lua Errors

Enable verbose logging.

Check:

```text
data/logs/
```

and console output.

---

# Development Workflow Summary

```text
Create Branch
      ↓
Implement Feature
      ↓
Build
      ↓
Run Tests
      ↓
Manual Validation
      ↓
Update Documentation
      ↓
Open Pull Request
      ↓
Code Review
      ↓
Merge
```

---

# Conclusion

Canary development is centered around:

* C++20 for engine performance
* Lua for gameplay flexibility
* CMake for reproducible builds
* vcpkg for dependency management
* Automated testing and code review

Contributors are encouraged to keep changes modular, documented, tested, and aligned with the project's goal of providing a modern and extensible MMORPG server platform.
