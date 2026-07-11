# Gameplay Analytics schema migrations

Gameplay Analytics uses an explicit schema version so runtime code cannot silently write against an outdated database.

## Fresh installation

Apply the baseline schema and then all pending migrations:

```bash
mariadb -u canary -p canary < schema/gameplay_analytics.sql
DB_HOST=127.0.0.1 \
DB_PORT=3306 \
DB_USER=canary \
DB_PASSWORD='your-password' \
DB_NAME=canary \
bash tools/analytics/migrate_gameplay_analytics.sh
```

The baseline schema creates `analytics_schema_migrations` and records version `1`. The migration runner applies files from `schema/gameplay_analytics_migrations` in numeric order.

## Existing installation

The runner recognizes an existing `analytics_sessions` table without migration metadata as baseline version `1`. It then applies later migrations. Run it before enabling a newer Analytics runtime.

Current migrations:

- `002_server_version_index.sql` adds `(server_version, started_at)` for comparisons across builds;
- `003_hunt_context.sql` adds hunt-area, dynamic party and shared-experience context plus `(hunt_area, started_at)`.

## Runtime protection

The current runtime requires schema version `3`. When `enabled = true` and database persistence is active, startup reads the latest version from `analytics_schema_migrations`.

Analytics remains stopped when:

- the migration table does not exist;
- the table cannot be queried;
- the installed version is lower than the required version.

Schema rejection also sets the in-memory Analytics switch to disabled, so combat callbacks cannot accumulate sessions without an active flush loop. Gameplay continues normally; only Analytics collection remains inactive.

Use the administrative command to recheck after a migration:

```text
/analytics schema
```

After a successful migration, explicitly run `/analytics enable` or restart Canary with `enabled = true`.

The standard `/analytics status` output includes the current version, required version and readiness state.

## Immutability and checksums

Every numbered migration is recorded with its SHA-256 checksum. Re-running the same migration is a no-op. Modifying a migration that was already applied causes the runner to stop with a checksum mismatch.

Never edit an applied migration. Add the next numbered file instead:

```text
004_description.sql
005_another_change.sql
```

DDL statements should be idempotent where MariaDB supports it because many DDL operations perform an implicit commit. Insert the migration row only after the SQL file succeeds.

## Deployment order

1. Back up the database.
2. Deploy the new migration files and runner.
3. Run `migrate_gameplay_analytics.sh`.
4. Confirm `/analytics schema` reports version `3/3` and readiness `true`.
5. Deploy or enable the new runtime.

The CI integration test performs the baseline import twice, runs the migration runner twice, checks both production indexes and hunt-context columns, persists a context-rich session, and deliberately mutates an applied migration to verify checksum protection.
