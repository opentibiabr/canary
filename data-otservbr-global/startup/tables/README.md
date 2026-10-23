# Legacy world configuration

These Lua tables are frozen compatibility configuration for `legacy` and
`mixed` startup. The authoritative configuration for the distributed World
mode lives in the datapack's `world/` JSON catalog and layers. Edit that content
through RME or directly in JSON; do not maintain both formats in parallel.

Legacy world configuration will be discontinued in a future release. No removal
release has been selected. Existing configurations without `worldConfiguration`
continue to use legacy mode and emit a migration notice.

`storage_keys_update.lua` is an exception: it updates player persistence and
continues to load in every mode. Quest-state resets also remain execution logic.

See [World migration](../../../docs/systems/world-migration.md) for complete or
selected migration, ownership, explicit return to legacy and conflict recovery.
