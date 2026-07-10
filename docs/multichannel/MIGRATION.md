# Migration Guide

## Before you start

**Take a full database backup.** This is not optional. The house-related
migration (`60.lua`) changes the primary key of a table with foreign-key
children. It has been written as carefully as the existing migration
patterns allow and is idempotent (safe to re-run / resume after a partial
failure, same as every other migration in this repo), but it has **not**
been executed against a live MySQL/MariaDB server in this development
session — there was no database server available in the sandbox this PR
was built in. Test it against a staging copy of your database before
running it against production. This limitation is stated plainly rather
than glossed over; see TEST_PLAN.md for exactly what *was* validated.

## What the migrations do

### `data-otservbr-global/migrations/59.lua` — cluster registry & audit tables

Purely additive (`CREATE TABLE IF NOT EXISTS`, matching every existing
migration's idempotency pattern):

- `channels`
- `channel_runtime_status`
- `cluster_sessions`
- `channel_switch_audit`
- `economic_ledger`
- `account_house_ownership`
- `ALTER TABLE market_offers ADD COLUMN source_channel_id ...` (guarded by
  a column-existence check)
- `ALTER TABLE market_history ADD COLUMN source_channel_id ...` (same)
- `ALTER TABLE guildwar_kills ADD COLUMN channel_id ...` (same)
- Seeds one row into `channels` for `id = 1` from the server's *current*
  `config.lua` values (`SERVER_NAME`, `IP`, `GAME_PORT`, `STATUS_PORT`,
  `worldType`), so an upgraded single-channel server has a valid Channel 1
  row without any manual step, and `account_house_ownership` is backfilled
  from every existing `houses.owner != 0` row (one INSERT per current
  owner, skipped via `INSERT IGNORE` semantics if a row already exists —
  this makes the migration safe to run twice).

This migration is safe on any existing installation: it adds tables and
nullable columns only, does not touch primary keys, and does not change
any existing row's meaning. Running it does **not** turn on multi-channel
behavior by itself — that is controlled entirely by
`multiChannelEnabled` in `config.lua`.

### `data-otservbr-global/migrations/60.lua` — house composite identity

This one is structural:

1. `ALTER TABLE houses ADD COLUMN channel_id INT NOT NULL DEFAULT 1`
   (guarded by column-existence check).
2. `ALTER TABLE house_lists ADD COLUMN channel_id INT NOT NULL DEFAULT 1`.
3. `ALTER TABLE tile_store ADD COLUMN channel_id INT NOT NULL DEFAULT 1`.
4. Drop the old foreign keys from `house_lists` and `tile_store` to
   `houses(id)`.
5. Drop `houses`' old primary key and `AUTO_INCREMENT` on `id` (safe — see
   DECISION_MATRIX.md, existing code always inserts an explicit id), add
   `PRIMARY KEY(channel_id, id)`.
6. Add a plain `UNIQUE KEY (id)` secondary index on `houses` — kept
   deliberately, even though it makes `id` globally unique for now (i.e.
   this migration does not yet let two channels reuse the same numeric
   house id) — see "Known limitation" below.
7. Re-add the foreign keys on `house_lists(channel_id, house_id)` and
   `tile_store(channel_id, house_id)` referencing
   `houses(channel_id, id)`.

Every step is guarded by an existence check (`information_schema` query
for the column/index/constraint) so re-running the migration after a
partial failure does not error out on "column already exists" — same
resumability contract as the rest of the migration system.

**Known limitation (stated honestly):** step 6's `UNIQUE KEY(id)` means
this migration does not yet allow two different channels to independently
own a house with the *same* numeric id — which the spec explicitly wants
("House ID może powtarzać się między kanałami"). Removing that constraint
safely requires re-numbering house ids from the map/OTBM loader in a way
that's consistent across every channel process at boot, which touches the
house-loading code path (`Houses::loadHousesXML`,
`IOMapSerialize`) that this session cannot compile/test. Shipping the
*globally-unique-id* variant now is the safer intermediate state: it keeps
existing single-channel installs byte-for-byte compatible (every house
keeps its current id, `channel_id` defaults to `1`) and does not silently
allow two unrelated houses on different channels to collide under the same
id before the loader is actually updated to disambiguate them. Lifting
this is tracked as Phase 2 work in DECISION_MATRIX.md.

## Rollback

Both migrations only add tables/columns and change one table's key
structure; nothing destroys data. To roll back `60.lua` specifically
(restore `houses` to a single-channel-only shape):

```sql
ALTER TABLE house_lists DROP FOREIGN KEY house_lists_channel_house_fk;
ALTER TABLE tile_store DROP FOREIGN KEY tile_store_channel_house_fk;
ALTER TABLE houses DROP PRIMARY KEY, DROP INDEX houses_id_unique;
ALTER TABLE houses ADD PRIMARY KEY (id), MODIFY id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE house_lists ADD CONSTRAINT houses_list_house_fk FOREIGN KEY (house_id) REFERENCES houses(id) ON DELETE CASCADE;
ALTER TABLE tile_store ADD CONSTRAINT tile_store_account_fk FOREIGN KEY (house_id) REFERENCES houses(id) ON DELETE CASCADE;
ALTER TABLE houses DROP COLUMN channel_id;
ALTER TABLE house_lists DROP COLUMN channel_id;
ALTER TABLE tile_store DROP COLUMN channel_id;
```

Rolling back `59.lua` is simply dropping the new tables and the three
added audit columns; there is no data to reconcile since nothing else
writes to them yet in this PR.

The recommended path for a production rollback, regardless, is restoring
the pre-migration backup rather than running the reverse DDL under time
pressure — the reverse script above is provided for completeness and for
staging-environment testing, not as a substitute for the backup.

## Upgrade path to enable multi-channel

1. Back up the database.
2. Deploy this PR's binary, keep `multiChannelEnabled = false`. Start the
   server normally once — this runs `59.lua`/`60.lua` and confirms nothing
   broke in single-channel mode (existing behavior is fully preserved with
   the flag off).
3. Decide on your channel topology and `INSERT`/`UPDATE` the seeded
   `channels` table row(s) accordingly (name, ports, `pvp_type`,
   `max_players`, `temple_town_id`).
4. Provision Redis (required once `multiChannelEnabled = true` — not
   required before).
5. Set `multiChannelEnabled = true`, configure `redisHost`/etc., set
   `CANARY_CHANNEL_ID`/`--channel-id` per process, start each process.
6. Follow OPERATIONS.md for day-2 monitoring.

Phase 1 does not yet wire session/switch/economy enforcement into the live
engine (see ARCHITECTURE.md), so turning `multiChannelEnabled = true`
today activates the login-list multi-world display and the startup
validator's config-shape checks, but does **not** yet enforce one-session-
per-account or perform live channel switches end-to-end — that requires
the Phase 2 PR. Do not enable this flag in production before Phase 2 ships
and is tested; it is included now so the schema/config/docs contract is
complete and reviewable end-to-end.
