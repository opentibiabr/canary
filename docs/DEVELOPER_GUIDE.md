# Developer Guide 🛠️

Welcome to the Canary codebase! This guide will help you understand the project structure and set up your development environment.

## 📂 Project Structure

| Directory | Description |
| :--- | :--- |
| `src/` | The core C++20 source code. |
| `data-canary/` | The default datapack containing scripts, monsters, NPCs, and map configuration. |
| `docker/` | Dockerfiles and compose configurations for containerized deployment. |
| `docs/` | Documentation and python scripts for generating docs. |
| `cmake/` | CMake modules and configuration. |
| `schema.sql` | The MySQL database schema. |

## ⚙️ Environment Setup

### Option A: Docker (Recommended)
The easiest way to start developing is using Docker. The `Dockerfile.dev` allows you to compile and run the server inside a container.

```bash
cd docker
docker-compose up -d --build
```

### Option B: Manual Build (C++)

If you prefer running on bare metal, you will need a C++20 compatible compiler (GCC 11+, Clang 14+, or MSVC). We use **vcpkg** for dependency management.

#### Prerequisites
- CMake 3.20+
- Ninja / Make
- vcpkg

#### Building on Linux/macOS
```bash
# Configure with CMake Presets
cmake --preset linux-debug

# Build
cmake --build --preset linux-debug
```

#### Building on Windows
Open the folder in Visual Studio 2019/2022 and let it handle the CMake configuration via `CMakePresets.json`.

## 🗄️ Database

Canary uses **MariaDB/MySQL**.

1. **Schema**: You must import `schema.sql` into your database before starting the server for the first time.
2. **Configuration**: Edit `config.lua` (will be created from `config.lua.dist`) to set your DB credentials.

### KV System
Canary features a powerful Key-Value store to avoid frequent schema changes.
👉 [**Read the KV System Documentation**](../src/kv/README.md)

## 🧪 Testing

Run unit tests using CTest:

```bash
ctest --preset linux-debug
```

## 🤝 Contributing

Please ensure you have read the [CONTRIBUTING.md](../CONTRIBUTING.md) file. We strictly follow:
- **Clang Format** for C++.
- **Lua Format** for Scripts.
