# Migration Guide

## Before you start

**Take a full database backup.** This is not optional, even though this
migration has since been executed and verified against a real MariaDB
10.11 server in this session (see "What was actually verified" below) -
your production data/config may differ from the test fixtures used here,
and a backup is cheap insurance regardless.

## What was actually verified against a real database

`apt-get install mariadb-server` turned out to work in this sandbox
(earlier attempts at a working Docker daemon had failed, but a bare
`mariadbd` process did not need one). Against a real, running MariaDB
10.11 instance, this session:

1. Imported `schema.sql` (fresh install) into an empty database - clean,
   no errors, all 7 new tables plus the composite `houses` identity
   present exactly as designed.
2. Reconstructed a "v58-equivalent" database from this repo's `schema.sql`
   as it existed immediately before this PR (`git show <pre-PR commit>`),
   then applied the exact SQL bodies from `59.lua` and `60.lua`, in their
   real file order, as a genuine upgrade simulation - succeeded cleanly.
3. Diffed the upgraded `houses` table against the fresh-install one:
   identical except column order (`channel_id` lands at the end via
   `ADD COLUMN` instead of right after `id`) - cosmetic only, not a
   functional difference.
4. Verified every migration guard query (`SHOW COLUMNS ... LIKE
   'channel_id'`, `SHOW KEYS ... WHERE Column_name = 'channel_id'`,
   `information_schema` table-existence check) returns exactly the result
   the Lua guard logic expects to see after the migration has already run
   - i.e. confirmed a second run would correctly no-op every step instead
   of erroring, which is the resumability property §13 of the spec
   requires.
5. Seeded a house owned by an existing player/account *before* running the
   migration, then confirmed the `account_house_ownership` backfill query
   populated exactly one correct row from the join.
6. Attempted to violate every anti-dupe constraint this PR's schema adds,
   against the real database, and confirmed each one is actually
   rejected: a second house for the same account
   (`account_house_ownership.PRIMARY KEY(account_id)`), a second account
   claiming the same physical house
   (`account_house_ownership_house_unique(channel_id, house_id)`), a
   second `cluster_sessions` row for the same account
   (`PRIMARY KEY(account_id)`), and a second `cluster_sessions` row for
   the same player under a different account
   (`cluster_sessions_player_unique`).
7. Ran the reverse-rollback SQL documented below against the upgraded
   database and confirmed it restores the exact pre-migration `houses`
   shape.

**A real bug was found and fixed by this process**: the first version of
this migration/schema declared `account_id` as a plain signed `int(11)`
on `cluster_sessions`, `channel_switch_audit`, `economic_ledger`, and
`account_house_ownership` - but `accounts.id` in this schema is
`int(11) UNSIGNED`, and every *other* table in this schema that
references it already declares its own `account_id` as `UNSIGNED` too.
MariaDB rejected the mismatched foreign key outright
(`errno 150 "Foreign key constraint is incorrectly formed"`) the moment
`schema.sql` was imported for real. Fixed in both `schema.sql` and
`59.lua` before this PR was finalized - this is exactly the class of bug
a real database catches instantly and a design review can miss.

What is still *not* verified: production-scale data volumes, MySQL (as
opposed to MariaDB) specifically, concurrent migration runs, and the
`data-canary` datapack (which, per its own note further down, has no
numbered migration history to extend in the first place).

## What the migrations do

**Convention note, found the hard way (see below):** `schema.sql` seeds
`server_config.db_version` explicitly (currently `60`) so that a fresh
install - which already has the full target schema baked in - doesn't
re-run every historical migration against a database that already has
their tables. Whenever a new migration is added, this seed **must** be
bumped to match the new latest migration number, or `DatabaseManager`
will try to run it anyway on a fresh install, hit its own idempotency
guard ("already exists, skipping"), log a warning, and - in this repo's
CI, which runs its runtime smoke test with `--fail-on-warnings` - fail
the build. This PR bumped the seed from `58` to `60` for exactly that
reason; a real CI run (not a review) is what caught it being missed on
the first push.

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
- Backfills `account_house_ownership` from every existing
  `houses.owner != 0` row (one `INSERT IGNORE` per current owner — safe to
  run twice).

Channel 1 is **not** seeded by this Lua migration: migrations run in a
restricted Lua sandbox (`CoreLibsFunctions` — `db`/`logger`/`Result`/
`metrics`/`kv` only, deliberately not the full script API, so it has no
`configManager` binding and cannot read `config.lua`). Seeding a
meaningful Channel 1 row (name, IP, ports, `pvp_type` from the *current*
`config.lua`) instead happens once, in C++, at `ChannelRegistry` startup
(`ChannelRegistry::ensureBootstrapChannel`, ✅ implemented): if
`multiChannelEnabled = true`, the resolved `channelId` is `1`, and the
`channels` table has no row for id `1`, the registry inserts one from the
live `ConfigManager` values (`SERVER_NAME`, `IP`, `GAME_PORT`,
`STATUS_PORT`, `worldType`). This runs exactly once (guarded by the row's
existence) and only ever creates the bootstrap row for id `1` — every
other channel is expected to be configured explicitly by the operator, not
auto-guessed.

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

**Updated status (Phase 2):** turning `multiChannelEnabled = true` now
activates the login-list multi-world display, the startup validator,
**real cluster-wide session enforcement** (a second login attempt for an
already-online account is genuinely rejected, or the holder is force-
disconnected if its lease becomes unrenewable during a Redis outage), and
**a real live channel switch**: `player:requestChannelSwitch(channelId)`
(a Lua method an operator wires into any talkaction/command) evaluates the
full policy against the player's live state and, on success, resolves an
arrival position and performs a normal clean disconnect; logging back in
on the target channel picks up that resolved position automatically. See
ARCHITECTURE.md §5/§6 for exactly what's wired and its stated gaps (most
notably: the `cluster_sessions` DB table isn't dual-written yet, so Redis
is the sole session-enforcement mechanism; and target-channel online/
capacity checks are optimistic placeholders since no heartbeat loop exists
yet to check them for real).

**Phase 3:** `House::setOwner` — the one real chokepoint every ownership
change (auction win, trade-based sale, rent/inactivity repossession)
funnels through — now mirrors every grant/revoke into
`account_house_ownership` for real, verified against a real MariaDB
(grant, re-grant moves the row, revoke deletes it; see ARCHITECTURE.md
§7 and TEST_PLAN.md). This makes the cluster-wide "one house per account"
table accurate as of *this* PR, not just from whenever an operator
eventually flips the flag — no backfill migration will be needed later.

**Still not enforced**, and still the reason not to enable
`multiChannelEnabled = true` in production yet: nothing yet *blocks* an
account from bidding on or trading for a second house before an already-
decided purchase for a different one settles (the mirror above only
records an outcome once `setOwner` is actually called, which for auctions
happens on the next restart, not at bid-placement time) — see
ARCHITECTURE.md §7's stated gap. The economy ledger (§8) — market/mail/
bank idempotency — is also still entirely unwired; a switch or a normal
login does not touch money-moving state at all today, which is the safe
side to be wrong on, but also means this is not yet a complete cluster.
Do not enable `multiChannelEnabled = true` in production until those ship
and are tested.
