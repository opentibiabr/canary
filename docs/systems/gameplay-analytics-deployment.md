# Gameplay Analytics production deployment

This document packages a repeatable production rollout for Gameplay Analytics
on top of the schema, persistence, reliability and migration behaviour already
described in `docs/systems/gameplay-analytics.md`. It does not introduce new
runtime behaviour; it only sequences the existing installation, verification
and configuration steps so a production rollout is safe and reversible.

Out of scope: retention scheduling (`docs/systems/gameplay-analytics-retention.md`),
spell/supply/loot integration work, and dashboarding. See those documents for
those subsystems.

## Files used by this rollout

- `tools/analytics/gameplay-analytics.env.example` — example environment file.
- `tools/analytics/install_gameplay_analytics.sh` — applies the baseline schema
  and runs pending migrations. Never edits Lua configuration.
- `tools/analytics/migrate_gameplay_analytics.sh` — migration runner (invoked
  by the installer, also usable standalone for later migrations).

## Prerequisites

- A MariaDB user with DDL privileges on the Canary database.
- A recent database backup. Migrations run DDL and, per
  `gameplay-analytics-migrations.md`, are not designed to be reverted; a
  backup is the actual rollback mechanism for schema changes.
- Gameplay Analytics stays `enabled = false` in
  `data-otservbr-global/scripts/config/gameplay_analytics.lua` until step 7.

## 1. Prepare the environment file

Copy the example file to a secured location and fill in real values:

```bash
cp tools/analytics/gameplay-analytics.env.example /etc/canary/gameplay-analytics.env
chmod 600 /etc/canary/gameplay-analytics.env
```

Edit `/etc/canary/gameplay-analytics.env` and replace both `CHANGE_ME`
placeholders with the real `DB_PASSWORD` and a stable `CANARY_SERVER_VERSION`
build identifier (for example `balance-2026-07-11`). Never commit the filled-in
file; only the placeholder example belongs in version control.

## 2. Run the installation script

```bash
set -a
source /etc/canary/gameplay-analytics.env
set +a
bash tools/analytics/install_gameplay_analytics.sh
```

The script applies `schema/gameplay_analytics.sql`, runs
`migrate_gameplay_analytics.sh`, and confirms the installed schema version.
It is repeatable: the baseline schema uses `CREATE TABLE IF NOT EXISTS` and the
migration runner is idempotent by checksum, so re-running after a partial
failure is safe. On any failure the script exits non-zero before printing the
verification checklist, and it never edits the Lua configuration or the
`enabled` flag.

## 3. Export CANARY_SERVER_VERSION to the Canary process

The Lua configuration reads the build identifier from the environment:

```lua
serverVersion = os.getenv("CANARY_SERVER_VERSION") or ""
```

Export the same `CANARY_SERVER_VERSION` value used in step 1 to the Canary
process itself, for example through a systemd `EnvironmentFile=` pointing at
`/etc/canary/gameplay-analytics.env` (or your existing service environment
file), then start or restart Canary.

## 4. Start Canary with Analytics still disabled

Start (or restart) Canary normally. `enabled` is still `false`, so nothing
changes for players. A database outage or schema mismatch at this point does
not stop Canary from starting; Analytics simply stays disabled and the game
server continues to run normally (see "Schema compatibility" in
`gameplay-analytics.md`).

## 5. Verify `/analytics schema`

As a gamemaster:

```text
/analytics schema
```

Confirm the reply shows `ready=true`, `current=3`, `required=3`, `error=none`.
Do not continue if `ready` is `false` or `error` is set; fix the underlying
database issue and re-run the installation script instead.

## 6. Verify `/analytics status`

As a gamemaster:

```text
/analytics status
```

Confirm `schemaReady=true` with no `schemaError`, and that queue and
dead-letter counters are at their startup baseline (zero, since Analytics has
not started collecting yet).

## 7. Enable Analytics only after both checks pass

Set in `data-otservbr-global/scripts/config/gameplay_analytics.lua`:

```lua
enabled = true
databaseEnabled = true
```

Restart Canary and confirm the startup log contains `[GameplayAnalytics]
Enabled`. Re-run `/analytics status` to confirm `enabled=true` and
`running=true`.

## Rollback

### Before enabling (the common case)

If verification fails at step 5 or 6, no rollback is required: Analytics is
still disabled by default and Canary keeps running normally. Fix the
underlying database issue and re-run `install_gameplay_analytics.sh`, which is
safe to repeat.

### After enabling

- Immediate rollback: run `/analytics disable` as a gamemaster. This stops
  collection right away but resets to the Lua configuration on the next
  restart.
- Persistent rollback: set `enabled = false` in the Lua configuration and
  restart Canary.
- Database rollback: schema migrations are additive and are not automatically
  reverted. Restore from the pre-installation backup if a migration must be
  undone. Never edit a migration file that has already been applied; add the
  next numbered migration instead (see `gameplay-analytics-migrations.md`).

## Failure isolation

- Missing or placeholder `DB_PASSWORD` — the installer exits before running
  any SQL.
- Unreachable database during installation — the installer exits non-zero;
  Canary is unaffected because it has not been started or restarted yet.
- Unreachable database or stale schema at Canary startup — Analytics stays
  disabled; Canary starts and continues running normally.
- Failed verification (`/analytics schema` or `/analytics status`) — the
  operator simply does not proceed to step 7; nothing was enabled.

Database or Analytics failures must never prevent Canary from starting, at
installation time or at runtime.
