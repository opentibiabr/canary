# Research normalization

The research normalization layer converts reviewed quest, NPC, monster, and item notes into a stable JSON representation before any content planning or rendering begins.

## Inputs

- a research document matching `RESEARCH_ENTITY.schema.json`,
- the generated Canary `CONTENT_INDEX.json`.

Each entity declares whether it is canonical Tibia content or custom OTS content and carries explicit source references. Facts remain source notes; they are not treated as executable Canary configuration.

## Comparison result

`normalize_research.py` compares entity type and normalized name against the Canary content index. Every entity receives one of two states:

- `matched` — one or more existing Canary definitions were found,
- `missing` — no matching Canary definition was found.

A missing entity is not automatically an error. For custom OTS content it normally means that implementation has not been added yet. For canonical content it indicates that a human should verify spelling, aliases, datapack scope, and source accuracy.

## Safety boundary

Normalization never writes to an active datapack. It does not modify OTBM files, `items.otb`, Lua gameplay files, or server configuration. Its output is a review artifact used by later dry-run planning stages.
