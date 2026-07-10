# Canary content conventions for AI authoring

This audit is based on existing repository structure and is intentionally conservative.

## Locations and registration

- Monsters are indexed from datapack monster directories and XML-style definitions; generated previews must stay under `artifacts/generated-content` until a human ports them.
- NPC, quest, action, movement, spell, raid, creaturescript, and globalevent content is registered through datapack scripts and XML/Lua registration files depending on the subsystem.
- Active datapacks (`data` and `data-otservbr-global`) are not safe dry-run write targets.

## Lua object patterns

Canary Lua content commonly defines a local object or callback functions, registers event hooks, and returns no reusable library API. Renderers should not invent APIs and should produce manual notes when registration details are uncertain.

## Identifiers

Storage values, action IDs, unique IDs, and item IDs are scanned by `scan_ids.py`. Reuse as a reference is not necessarily a conflict; repeated definitions are the high-risk case. Item IDs can be referenced and reserved for planning, but new item integration requires manual review because `items.otb` is protected.

## Quests and rewards

Quest plans should separate storage progress, NPC dialog, kill objectives, action ID use, movement/position requirements, collection objectives, rewards, tests, rollback, and map requirements. Map work remains manual.

## Unsafe automation boundaries

The pipeline must not modify OTBM files, `items.otb`, active datapacks, production configuration, or publish generated content automatically.
