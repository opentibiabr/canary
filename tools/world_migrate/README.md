# World migration

Run the package from the repository root with Python 3.12. It uses the existing
`canary_audit` lexer for static Lua analysis. It never executes Lua or uses `eval`.
Validation, original-item selection and publication use the distributed native
`world-tool`; no server compilation is needed to migrate a datapack.

```sh
python -m tools.world_migrate analyze --datapack data-otservbr-global --all
python -m tools.world_migrate analyze --datapack data-otservbr-global --file startup/tables/item.lua --table ItemAction --entry 13107 --report artifacts/world-migration/analysis.json
python -m tools.world_migrate generate --report artifacts/world-migration/analysis.json --output artifacts/world-migration/bundle --world-tool ./world-tool
python -m tools.world_migrate validate --bundle artifacts/world-migration/bundle --world-tool ./world-tool
python -m tools.world_migrate apply --bundle artifacts/world-migration/bundle --world-tool ./world-tool --confirm-offline
python -m tools.world_migrate revert --receipt data-otservbr-global/world/migrations/migration-id.json --world-tool ./world-tool --confirm-offline
```

`analyze` reads `worldConfiguration` statically. A missing option has the
compatibility value `legacy`. Dynamic or repeated assignments are reported as
unknown; rerun with `--mode legacy`, `--mode world` or `--mode mixed` only after
choosing the intended analysis profile. The report and bundle retain that
choice and the exact `config.lua` revision, including the absence of that file.
Application is refused if the configuration revision changes.

On Windows, use the same arguments on a single line and `world-tool.exe`, for
example `--world-tool "tools-bin/world-tool.exe"`. Alternatively, set
`WORLD_TOOL_PATH` to the helper or install it on `PATH`. `--project` selects a
catalog when the datapack has more than one. If no catalog exists, generation
prepares a sibling catalog for the sole OTBM in `world/`; use `--project` and
`--map` when the target is ambiguous or the map is stored elsewhere. A new
catalog remains inside the review bundle until `apply`. Reversion removes it
only when its published revision still matches. `--map` reads the matching OTBM from
another local path; its SHA-256 must match the map used during generation.

Analysis only prints results unless `--report` is present. Generation reserves a
new output directory and writes reviewable before/after snapshots, the inventory
and a bundle manifest. It does not activate the result. A failed or incomplete
generation leaves its output available for inspection; choose a new directory
when generating again. Existing files are never silently replaced at this step.

The converters cover AID/UID assignments, explicit false selectors, sign text,
books in existing containers, item creation, teleports, tile mechanisms and quest
rewards, including the consumer's reward text and achievements. Consumer patches
apply only to recognized source revisions. Customized consumers remain pending;
their filename alone does not authorize replacing them. Pending
declarations or unresolved Lua consumers block application, even if the generated
JSON is structurally valid. Repeated or shadowed Lua keys require explicit
characterization; they are not merged or resurrected automatically.

The report also contains a separate `dispatch` inventory for Action and
MoveEvent registrations. It records the registration category that actually
succeeded, selectors rejected as duplicates, position/UID/AID/itemId priority,
equipment slot filters and the ordered MoveEvent sequence. Cross-file order,
dynamic selectors and callbacks with shared mutable locals remain behavior
pending. These findings do not block an independently safe AID/UID adoption;
they do block treating an arbitrary numerical match as proof that a handler can
be replaced. The maintained consumer adapters still require their own exact
source revisions and closed behavior contract.

Repository-specific decisions are supplied explicitly with
`--resolutions tools/world_migrate/resolutions/data-otservbr-global.json` during
generation. This evidence is bound to the inspected map hash, declaration
fingerprints and any characterized consumer dependencies. It documents inactive
placeholders, shadowed entries, competing loader assignments and UID collisions.
It is never selected automatically for another installation. LuaJIT traversal
order was characterized for the competing assignments; Lua 5.4 iteration order
is not assumed to be equivalent.

The native identifier census includes every map item with AID or UID, whether it
is selected or not, including ground and nested container children. UID
validation runs on the resulting canonical instances: a base item and its World
override count once, while creates and replacements are included separately.
Removing an item from a batch does not remove it from this validation. No command
renumbers or clears a conflict automatically. AID sharing never implies
ownership of another object.

Review `bundle.json`, `analysis.json` and `after/` before applying. The bundle's
snapshots are immutable revision preconditions: editing them invalidates the
bundle. Regenerate from reviewed source changes instead. Selecting entries keeps
the complete inventory and leaves unselected declarations and comments intact.
Legacy source tables remain as compatibility configuration; there is no ongoing
Lua/JSON synchronization.

The complete OTBM hash is an application guard and immutable historical evidence
in the receipt. It is not a permanent startup dependency. After publication,
selectors and occurrence fingerprints validate each adopted item locally, so a
distant terrain edit does not invalidate unrelated World objects. A changed
target or ambiguous sibling set produces a diagnostic for that object.

Apply and revert require the server and editing sessions to be stopped. They use
the shared native file service for revisions, cooperative locking, displaced
versions, interrupted writes and recovery. The ownership record points to its
receipt; recovery snapshots live under `world/migrations/.recovery/`. Those
snapshots are not listed as active catalog content. Keep them while rollback is
required. The OTBM is inspected and hashed but never modified.

Reapplying the same bundle is a no-op when all resulting files still match its
receipt. Reversion restores the previous files after validating the reconstructed
old project. Neither operation overwrites later JSON/Lua edits. A conflict must be
reviewed rather than forced. The receipt remains after reversion, allowing repeat
revert or reapply. Configuration-mode changes are explicit; the migration tool
does not silently switch a running installation between legacy, mixed and World.

For an interrupted publication, use the helper's `recover` command with the
original catalog and publication root; see [world-tool](../world_tool/README.md).

Run contract tests using an existing compatible native artifact:

```sh
python -m unittest discover -s tools/world_migrate/tests -t . -v
```

Set `WORLD_TOOL_PATH` first to include native OTBM, publication and full bundle
lifecycle tests. Without it, those native tests are explicitly skipped. Static
analysis tests still run. Native CTest runs the helper-backed tests automatically.
