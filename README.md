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

## Documentation

- [System documentation](docs/systems/README.md).
- [Lua API reference and VSCode IntelliSense stubs](docs/lua-api/lua_api.md). Canary generates these files from the C++ Lua bindings during startup when `generateLuaApiDocs` is enabled. For VSCode autocomplete, add `docs/lua-api` or `docs/lua-api/lua_api.d.lua` to the Lua Language Server workspace library.

---

## Recommended Tools and Clients

- [Assets Editor](https://github.com/Arch-Mina/Assets-Editor).
- [Remere's Map Editor](https://github.com/opentibiabr/remeres-map-editor/).
- [OTClient Redemption](https://github.com/opentibiabr/otclient).
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
