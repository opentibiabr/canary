# World migration

The migration tool reads the actual `startup/tables/load.lua` inventory and its
consumers without executing Lua. It requires Python 3.12. Configuration literals
are parsed structurally using the content auditor's lexer, retaining duplicate
keys, source locations and unresolved expressions. The native `world-tool` is the
authority for project and OTBM validation.

## Analyze

Run from the repository root. Analysis does not change files:

```sh
python -m tools.world_migrate analyze --datapack data-otservbr-global --all
```

Request a report explicitly to save the full inventory, source revisions,
declarations and consumer locations:

```sh
python -m tools.world_migrate analyze --datapack data-otservbr-global --file startup/tables/teleport.lua --table TeleportUnique --entry 38012 --entry 38013 --report artifacts/world-migration/analysis.json
```

These commands also work in PowerShell; quote paths containing spaces. Selection
marks entries in the complete inventory, so unselected declarations and consumers
remain available for conflict and coverage checks. A selection matching nothing
is an error. Empty tables are inventoried.

Classifications distinguish automatic configuration, known consumer adaptations,
inactive data, runtime state and cases requiring analysis. A classification is
not map validation or permission to activate unresolved data. Duplicate keys are
reported before evaluating a table; the tool never combines them or chooses a
winner implicitly. Constants require an identified static definition. Dynamic
expressions and unknown consumers block automatic conversion.

Player storage migrations remain in the existing execution path. The World
migration concerns configuration, not player or quest state.

## Development validation

```sh
python -m unittest discover -s tools/world_migrate/tests -v
```

Implementation and acceptance status are tracked in
[`world-implementation.md`](../../docs/systems/world-implementation.md). Generation,
native validation, application and reversal are subsequent implementation gates;
the analysis command does not claim those operations have completed.
