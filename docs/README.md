# Canary Documentation

This directory is the main documentation hub for the Canary repository.

---

# Documentation Index

This documentation is organized around four primary guides, with specialized
references in the surrounding subdirectories:

| Document                                  | Purpose                                                             |
| ----------------------------------------- | ------------------------------------------------------------------- |
| [`README.md`](README.md)                  | Project overview and documentation index                            |
| [`architecture.md`](architecture.md)      | System design, components and technical architecture                 |
| [`development.md`](development.md)        | Development environment, coding standards and contribution workflow  |
| [`operations.md`](operations.md)          | Deployment, monitoring, security, backups and production operations  |
| [`systems/content-reference-auditor.md`](systems/content-reference-auditor.md) | Profile-aware gameplay content and identifier auditing |

---

# What is Canary?

Canary is a modern MMORPG server engine that evolved from the OTServBR ecosystem. The project aims to provide a clean, maintainable, and extensible codebase that supports both custom game projects and OpenTibia-based servers. The repository includes support for multiple datapacks, Lua scripting, database persistence, a Docker quickstart for local testing, automated testing and observability tooling.

Key characteristics:

* C++20 core engine
* Lua gameplay scripting
* MariaDB/MySQL persistence
* Docker quickstart support for local testing and LAN demos
* Automated testing
* Metrics and observability
* Optional OpenTelemetry metrics integration
* Multiple datapack support
* Modern build tooling using CMake and vcpkg

---

# Documentation Structure

```text
docs/
├── README.md
├── architecture.md
├── development.md
├── operations.md
├── building/
├── docker/
├── lua-api/
└── systems/
```

---

# Architecture Guide

The Architecture Guide explains how Canary is built internally.

Topics include:

* High-level system architecture
* Core engine design
* Networking layer
* Protocol handling
* Creature system
* Combat engine
* Map management
* Lua integration
* Database architecture
* Event system
* Scheduler and dispatcher
* Metrics and observability

Read the [Architecture Guide](architecture.md).

Recommended for:

* Engine contributors
* System designers
* Technical reviewers
* Advanced server developers

---

# Development Guide

The Development Guide explains how to build, test and contribute to Canary.

Topics include:

* Development environment setup
* Docker development workflow
* Native compilation
* CMake usage
* vcpkg dependency management
* Lua development
* C++ coding standards
* Testing practices
* Pull request workflow
* Debugging techniques

Read the [Development Guide](development.md).

Recommended for:

* Contributors
* Developers
* Lua scripters
* Engine maintainers

---

# Operations Guide

The Operations Guide focuses on operating Canary safely, including native
production deployments and the limits of the local Docker quickstart.

Topics include:

* Infrastructure planning
* Deployment models
* Docker quickstart operations
* Configuration management
* Security practices
* Monitoring and alerting
* Backup strategies
* Disaster recovery
* Upgrade procedures
* Incident response

Read the [Operations Guide](operations.md).

Recommended for:

* Server administrators
* DevOps engineers
* Infrastructure teams
* Community operators

---

# Repository Overview

```text
canary/
│
├── src/                    # C++ server source code
├── data/                   # Core shared server resources
├── data-canary/            # Minimal Canary datapack
├── data-otservbr-global/   # Global datapack
├── docs/                   # Project documentation
├── tests/                  # Automated tests
├── docker/                 # Local Docker quickstart assets
├── metrics/                # Observability and metrics
│
├── schema.sql              # Database schema
├── config.lua.dist         # Configuration template
├── CMakeLists.txt          # Build configuration
├── CMakePresets.json       # Build presets
└── vcpkg.json              # Dependency manifest
```

The project supports both the lightweight `data-canary` datapack and the larger `data-otservbr-global` datapack, allowing operators to choose between a minimal engine-focused setup and a more complete game experience.

---

# Typical Lifecycle

The documentation follows the same lifecycle as a Canary deployment:

```text
Architecture
      ↓
Development
      ↓
Testing
      ↓
Deployment
      ↓
Operations
      ↓
Monitoring
      ↓
Maintenance
```

---

# Technology Stack

## Core Technologies

* C++20
* Lua
* MariaDB / MySQL
* CMake
* vcpkg

## Infrastructure

* Docker Compose quickstart
* GitHub Actions
* OpenTelemetry-based metrics
* Prometheus and Grafana examples

## Supported Platforms

* Linux
* Windows
* macOS

---

# Deployment Options

Canary can be run using:

## Docker

Recommended for:

* Local development
* Testing
* LAN demos

The repository Docker Compose stack is a quickstart. It uses the published
Canary runtime image, builds the MyAAC quickstart image, and should not be used
as a production deployment with default settings. See
[docker/DOCKER.md](../docker/DOCKER.md) for the complete quickstart contract.

## Native Installation

Recommended for:

* Production environments
* Custom infrastructure
* Advanced monitoring setups

The repository provides Docker quickstart assets, CMake build presets and
operational guidance for these approaches.

---

# Contributing

Contributors are encouraged to:

* Report bugs
* Improve documentation
* Write tests
* Submit pull requests
* Improve Lua systems
* Enhance engine functionality

Before contributing:

1. Read `architecture.md`
2. Read `development.md`
3. Follow coding standards
4. Run tests locally
5. Update documentation when necessary

---

# Additional Resources

* [Project repository](https://github.com/opentibiabr/canary)
* [Documentation index](README.md)
* [Releases](https://github.com/opentibiabr/canary/releases)

---

# Audience Guide

| Role                 | Recommended Reading                 |
| -------------------- | ----------------------------------- |
| New Contributor      | README → Development                |
| Lua Developer        | README → Development                |
| Engine Developer     | README → Architecture → Development |
| DevOps Engineer      | README → Operations                 |
| Server Administrator | README → Operations                 |
| Technical Lead       | README → Architecture → Operations  |

---

# Conclusion

The Canary documentation is organized around three core perspectives:

* **Architecture** — how the system works
* **Development** — how the system is built
* **Operations** — how the system is run

Together, these documents provide a complete reference for understanding, extending, deploying and operating Canary in both development and production environments.
