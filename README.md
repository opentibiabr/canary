# OpenTibiaBR - Canary

[![Discord Channel](https://img.shields.io/discord/528117503952551936.svg?style=flat-square&logo=discord)](https://discord.gg/gvTj5sh9Mp)
[![CI](https://github.com/opentibiabr/canary/actions/workflows/ci.yml/badge.svg)](https://github.com/opentibiabr/canary/actions/workflows/ci.yml)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=opentibiabr_canary&metric=alert_status)](https://sonarcloud.io/dashboard?id=opentibiabr_canary)
![GitHub repo size](https://img.shields.io/github/repo-size/opentibiabr/canary)
[![GitHub license](https://img.shields.io/github/license/opentibiabr/canary.svg)](https://github.com/opentibiabr/canary/blob/main/LICENSE)

OpenTibiaBR - Canary is a free and open-source MMORPG server emulator written in C++. It is a fork of the [OTServBR-Global](https://github.com/opentibiabr/otservbr-global) project. To connect to the server and to take a stable experience, you can use [mehah's otclient](https://github.com/mehah/otclient)
or [tibia client](https://github.com/dudantas/tibia-client/releases/latest) and if you want to edit something, check
our [customized tools](https://docs.opentibiabr.com/opentibiabr/downloads/tools). If you want to edit the map, use our own [remere's map editor](https://github.com/opentibiabr/remeres-map-editor/).

## Getting Started

- [Gitbook](https://docs.opentibiabr.com/opentibiabr/projects/canary).
- [Wiki](https://github.com/opentibiabr/canary/wiki).

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

## Support

If you need help, please visit our [discord](https://discord.gg/gvTj5sh9Mp). Our issue tracker is not a support forum, and using it as one will result in your issue being closed.

## Contributing

Here are some ways you can contribute:

- [Issue Tracker](https://github.com/opentibiabr/canary/issues/new/choose).
- [Pull Request](https://github.com/opentibiabr/canary/pulls).

You are subject to our code of conduct, read at [this link](https://github.com/opentibiabr/canary/blob/main/CODE_OF_CONDUCT.md).

## Special Thanks

- Our contributors ([Canary](https://github.com/opentibiabr/canary/graphs/contributors) | [OTServBR-Global](https://github.com/opentibiabr/otservbr-global/graphs/contributors)).

## Sponsors

See our [donate page](https://docs.opentibiabr.com/home/donate).

## Project supported by JetBrains

We extend our heartfelt gratitude to Jetbrains for generously granting us licenses to collaborate on this and various
other open-source initiatives.

<a href="https://jb.gg/OpenSourceSupport/?from=https://github.com/opentibiabr/canary/">
  <img src="https://resources.jetbrains.com/storage/products/company/brand/logos/jb_beam.svg" alt="JetBrains" width="150" />
</a>

## Partners

[![Supported by OTServ Brasil](https://raw.githubusercontent.com/otbr/otserv-brasil/main/otbr.png)](https://forums.otserv.com.br)
