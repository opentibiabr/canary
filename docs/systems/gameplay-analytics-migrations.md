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

Migration `002_server_version_index.sql` adds the index used to compare data across server builds:

```text
(server_version, started_at)
```

## Runtime protection

The current runtime requires schema version `2`. When `enabled = true` and database persistence is active, startup reads the latest version from `analytics_schema_migrations`.

Analytics remains stopped when:

- the migration table does not exist;
- the table cannot be queried;
- the installed version is lower than the required version.

Gameplay continues normally; only Analytics persistence remains inactive. The log explains how to run the migration script.

Use the administrative command to recheck after a migration:

```text
/analytics schema
```

The standard `/analytics status` output includes the current version, required version and readiness state.

## Immutability and checksums

Every numbered migration is recorded with its SHA-256 checksum. Re-running the same migration is a no-op. Modifying a migration that was already applied causes the runner to stop with a checksum mismatch.

Never edit an applied migration. Add the next numbered file instead:

```text
003_description.sql
004_another_change.sql
```

DDL statements should be idempotent where MariaDB supports it because many DDL operations perform an implicit commit. Insert the migration row only after the SQL file succeeds.

## Deployment order

1. Back up the database.
2. Deploy the new migration files and runner.
3. Run `migrate_gameplay_analytics.sh`.
4. Confirm `/analytics schema` reports the required version.
5. Deploy or enable the new runtime.

The CI integration test performs the baseline import twice, runs the migration runner twice, checks the resulting index and deliberately mutates an applied migration to verify checksum protection.
