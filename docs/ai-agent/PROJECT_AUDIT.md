# Canary AI Agent — Project Audit

Status: **in progress**

Audit branch: `ai/bootstrap-agent`

Base commit: `e8237cef7bf79c48189f2b9c2fcd46c84ae335df`

## 1. Confirmed project profile

- Engine: Canary.
- Languages: C++20 and Lua.
- Default branch: `main`.
- Default gameplay datapack: `data-otservbr-global`.
- Core datapack directory: `data`.
- Arbitrary datapack directories are disabled by default through `useAnyDatapackFolder = false`.
- Lua API documentation generation is enabled by default.
- Generated Lua API output directory: `docs/lua-api`.
- Default world type: PvP.
- Old supported protocol profiles are enabled by default.
- Default game port: `7172`.

## 2. Confirmed development capabilities

The repository provides the foundations required for an AI development agent:

- CMake presets for Linux, Windows and macOS,
- test-enabled build presets,
- CTest integration,
- Docker-based local runtime,
- MariaDB-based test environment,
- Lua API documentation generated from C++ bindings,
- server core, datapacks, scripts and database schema in one repository.

## 3. Safety policy for AI changes

The agent must not write directly to `main`.

Every task must use the following flow:

1. Create a dedicated `ai/*` branch.
2. Read and index affected systems.
3. Reserve identifiers where required.
4. Generate a change plan.
5. Apply changes.
6. Validate Lua, XML, SQL and map references.
7. Build the server when C++ is affected.
8. Run relevant tests.
9. Produce a diff and validation report.
10. Open a draft pull request for review.

## 4. Initial indexing targets

### Engine

- C++ Lua bindings,
- event and callback registration,
- item loading,
- monster loading,
- NPC loading,
- map loading and saving capabilities,
- database access,
- player storage handling,
- party and group systems,
- scheduler and dispatcher,
- test infrastructure.

### Core datapack

- common libraries,
- scripts shared between datapacks,
- events,
- actions,
- movements,
- creaturescripts,
- globalevents,
- spells.

### Global datapack

- world map and spawn data,
- monsters and bosses,
- NPCs and dialogue systems,
- quests,
- items and item metadata,
- raids,
- encounters,
- existing instance-like systems.

## 5. Required registries

The agent will build machine-readable registries for:

- storage keys and storage ranges,
- action IDs,
- unique IDs,
- item IDs,
- monster names,
- NPC names,
- quest names,
- script registrations,
- map positions,
- teleports,
- spawn regions,
- boss encounter identifiers.

## 6. First implementation milestone

The first usable milestone will be a read-only project indexer capable of answering:

- where a monster, NPC, item, quest or spell is defined,
- which files refer to a selected identifier,
- which systems depend on a selected script,
- whether a proposed storage/action/unique ID conflicts with existing content,
- which Lua API functions are available in this Canary fork.

## 7. Planned agent components

```text
ai-agent/
├── indexer
├── registries
├── schemas
├── validators
├── reports
└── mcp
    ├── repository
    ├── content
    ├── runtime
    └── testing
```

The map editing MCP will be added only after the map format, item metadata and map-loading implementation are fully audited.

## 8. Current unknowns

The following must still be confirmed from repository content and runtime tests:

- exact map file path and OTBM version,
- exact `items.otb` path and format version,
- map size and loading requirements,
- active quest framework or frameworks,
- storage allocation conventions,
- existing instance or arena framework,
- current Lua static-analysis coverage,
- Docker quickstart health in this fork,
- current build and test status of the audit branch.

## 9. Next audit outputs

The next files to be generated are:

- `PROJECT_STRUCTURE.json`
- `ENGINE_PROFILE.json`
- `CONTENT_INDEX.json`
- `ID_REGISTRY.json`
- `RISK_REPORT.md`
- `MCP_ARCHITECTURE.md`

## 10. Audit rule

No gameplay content or map data will be modified until the initial index, identifier registry and validation baseline are complete.
