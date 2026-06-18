# Canary

[![Discord](https://img.shields.io/discord/528117503952551936.svg?style=flat-square&logo=discord)](https://discord.gg/gvTj5sh9Mp)
[![CI](https://github.com/opentibiabr/canary/actions/workflows/ci.yml/badge.svg)](https://github.com/opentibiabr/canary/actions/workflows/ci.yml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=opentibiabr_canary&metric=alert_status)](https://sonarcloud.io/dashboard?id=opentibiabr_canary)
![Repository size](https://img.shields.io/github/repo-size/opentibiabr/canary)
[![License](https://img.shields.io/github/license/opentibiabr/canary.svg)](https://github.com/opentibiabr/canary/blob/main/LICENSE)

Canary is a free and open-source MMORPG server emulator for the OpenTibia community, written in C++20 and Lua. It is a fork of the [OTServBR-Global](https://github.com/opentibiabr/otservbr-global) project. The repository includes the server core, datapacks, Lua scripts, database schema, build presets, automated tests and development tooling used by the project.

---

## Getting Started

- [Wiki](https://github.com/opentibiabr/canary/wiki).

---

## Docker Quickstart

Canary includes a lightweight Docker quickstart for running a local test server
without compiling Canary locally. The stack starts MariaDB, the published Canary
runtime image, MyAAC as the website/admin AAC, and `opentibiabr/login-server` as
the client login webservice.

This quickstart is for local development, testing, and LAN demos. Do not expose
it directly to the public Internet with the default test accounts and passwords.

Run from the `docker` directory:

```bash
cp .env.dist .env
docker compose up -d --build
```

The `docker` directory also provides guarded start scripts that start the stack
and clean safe Docker leftovers without removing database volumes:

```powershell
.\up.ps1
```

```bash
sh ./up.sh
```

Default local endpoints:

- Website/admin: `http://localhost:8080`
- Client login webservice: `http://localhost:8088/login`
- Game port: `7172`

MyAAC's `login.php` is intentionally removed from the quickstart image. Clients
should use `login-server` only. See [docs/docker/quickstart-for-beginners.md](docs/docker/quickstart-for-beginners.md)
for a beginner guide and [docker/DOCKER.md](docker/DOCKER.md) for the full setup,
environment variables, test account, and troubleshooting guide.

---

## Documentation

- [Docker beginner quickstart](docs/docker/quickstart-for-beginners.md).
- [Multiprotocol runtime profiles](docs/systems/multiprotocol.md). Covers the
  current, 11.00, and 8.60 runtime contracts, port layout, client preparation,
  and validation checklist.
- [System documentation](docs/systems/README.md).
- [Lua API reference and VSCode IntelliSense stubs](docs/lua-api/lua_api.md). Canary generates these files from the C++ Lua bindings during startup when `generateLuaApiDocs` is enabled. The repository `.luarc.json` already adds `docs/lua-api` to the Lua Language Server workspace library; for VSCode workspace settings, run `tools/setup_vscode_lua_api.ps1`.

---

## Recommended Tools and Clients

- [Assets Editor](https://github.com/Arch-Mina/Assets-Editor). Use this as the
  single asset source of truth, then export legacy-compatible `.dat`/`.spr`
  packages for 8.60 clients from the same current asset set.
- [Remere's Map Editor](https://github.com/opentibiabr/remeres-map-editor/).
- [OTClient Redemption](https://github.com/opentibiabr/otclient).
- [Tibia Extended Client Library](https://github.com/dudantas/Tibia-Extended-Client-Library).
  Use this to prepare compatible 8.60/11.00 CipSoft clients with extended
  limits, config-driven login redirect, and per-client local state.
- [Game Client](https://github.com/dudantas/tibia-client/releases/latest).

---

## Nightly Packages

Development builds can be downloaded from GitHub Actions artifacts. They are useful for testing recent changes from the `main` branch, but may include behavior that is not present in stable releases yet.

- [Github Actions](https://github.com/opentibiabr/canary/actions/workflows/ci.yml?query=branch%3Amain).

---

## Running Tests

Tests can be run directly from the repository root using CMake test presets:

```bash
# Configure and build tests for your platform
cmake --preset linux-debug && cmake --build --preset linux-debug

# Run all tests
ctest --preset linux-debug

# For other platforms use:
# ctest --preset macos-debug
# ctest --preset windows-debug
```

For detailed testing information including adding tests and framework usage, see [tests/README.md](tests/README.md).

---

## Support & Community

For real-time support, join the [OpenTibiaBR Discord](https://discord.gg/gvTj5sh9Mp).

The GitHub issue tracker should be used for bugs, improvements and technical project tasks. It is not a support forum.

---

## Contributing

Contributions are welcome. You can help in several ways:

- Report bugs through the [Issue Tracker](https://github.com/opentibiabr/canary/issues/new/choose).
- Submit improvements through [Pull Requests](https://github.com/opentibiabr/canary/pulls).
- Improve tests, documentation, scripts, datapacks, or C++ code.
- Validate releases, nightly builds and recent changes.

Before contributing, read the [Code of Conduct](https://github.com/opentibiabr/canary/blob/main/CODE_OF_CONDUCT.md) and the project [Contributing](https://github.com/opentibiabr/canary/blob/main/CONTRIBUTING.md) guide.

---

## Sponsorship

Canary is maintained by community contributors. To support development, visit the [OpenTibiaBR sponsors page](https://github.com/sponsors/opentibiabr).

---

## Acknowledgements

Thanks to all contributors of [Canary](https://github.com/opentibiabr/canary/graphs/contributors), [OTServBR-Global](https://github.com/opentibiabr/otservbr-global/graphs/contributors) and the OpenTibia community.

---

## License

This project is distributed under the [GPL-2.0 license](https://github.com/opentibiabr/canary/blob/main/LICENSE).
