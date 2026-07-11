# Gameplay Analytics Grafana reporting package

This document covers the SQL reporting views, the Grafana dashboard, and how
to install both. It does not change Analytics collection behavior; it only
reads from tables that already exist once
`docs/systems/gameplay-analytics.md`, `-migrations.md` and `-retention.md`
have been applied.

## Files

- `schema/gameplay_analytics_views.sql` — reporting views (see below).
- `grafana/gameplay-analytics-dashboard.json` — the dashboard.
- `grafana/provisioning/datasources/mariadb.yaml.example` — datasource
  provisioning example, no credentials.
- `grafana/provisioning/dashboards/gameplay-analytics.yaml.example` —
  dashboard provisioning example.

## Prerequisites

1. `schema/gameplay_analytics.sql` and its migrations (`docs/systems/gameplay-analytics-migrations.md`).
2. `schema/gameplay_analytics_retention.sql` (`docs/systems/gameplay-analytics-retention.md`) — the views depend on `analytics_daily_balance` and the `(started_at, id)` index it adds.
3. `schema/gameplay_analytics_views.sql`:

   ```bash
   mariadb -u canary -p canary < schema/gameplay_analytics_views.sql
   ```

   Repeatable: every view uses `CREATE OR REPLACE VIEW`.

## Views and what backs each panel

| View | Reads | Used for |
|---|---|---|
| `analytics_daily_vocation_metrics` | `analytics_daily_balance` | EXP/h, DPS, damage taken/s, healing/s, deaths per 100 sessions, NPC profit/h, supply cost/h, shared experience %, session counts |
| `analytics_daily_party_mode_metrics` | `analytics_daily_balance` | Solo versus party |
| `analytics_dead_letter_health` | `analytics_dead_letters` | Pending dead-letter count, oldest/newest failure |
| `analytics_session_drilldown` | `analytics_sessions` (raw) | Ad-hoc drill-down only; not used by a shipped panel, provided for building your own short-range queries |
| `analytics_spell_efficiency_drilldown` | `analytics_session_spells` + `analytics_sessions` (raw) | Spell efficiency table |

The first two views read only the daily aggregate and are safe over long
date ranges. The last two read raw per-session detail and should only be
queried over short ranges (hours to a few days) — see "Daily aggregates
versus drill-down" below.

## Daily aggregates versus drill-down

`analytics_daily_balance` is written once per day per
(vocation, level bracket, hunt area, server version) by
`tools/analytics/maintain_gameplay_analytics.sh`. Querying it over months of
history touches at most a few hundred rows. Querying raw `analytics_sessions`
or `analytics_session_spells` over the same range touches every individual
hunting session — bounded in principle by `RAW_RETENTION_DAYS`, but still
much larger. The shipped dashboard therefore:

- uses `analytics_daily_vocation_metrics` / `analytics_daily_party_mode_metrics`
  for every long-range chart;
- uses `analytics_spell_efficiency_drilldown` only in a panel explicitly
  labeled "drill-down" with a note to keep the dashboard time range short;
- never queries raw `analytics_sessions` for a long-range chart.

If you add your own panels, keep this split: aggregate for trends, raw for a
specific short window.

## Minimum sample size

Every ratio in `analytics_daily_vocation_metrics` can be computed from very
few sessions and will look noisy or misleading at low volume. The dashboard
exposes a `Minimum sample size` text variable (default `20`, matching the
`HAVING COUNT(*) >= 20` convention already used in
`docs/systems/gameplay-analytics.md`'s example queries) and applies it as a
`sessions >= $min_sessions` filter on the trend panels. The "Session counts
and minimum sample-size warning" table intentionally does **not** filter by
it, so you can see which groups are currently below the threshold instead of
having them silently disappear.

## No per-player variables

The dashboard's template variables are `vocation_id`, `hunt_area`,
`server_version` and the `min_sessions` threshold. None of them are
per-player, matching the "no per-player, per-spell or per-monster labels"
principle already documented for `/analytics status`. Do not add a player
variable to this dashboard; per-player drill-down, if ever needed, should be
a separate, explicitly access-controlled tool, not a default dashboard
variable.

## Queue, retry, dead-letter and flush health

Only dead-letter counts are persisted to MariaDB (`analytics_dead_letters`),
so only those are charted here. Queue depth, in-flight retry counts, and
last-flush duration are process-local runtime counters (see
`docs/systems/gameplay-analytics.md`, "Administrative commands") that reset
on restart and have no MariaDB representation. The dashboard's health row
includes a text panel pointing operators at the in-game `/analytics status`
command for those instead of fabricating a chart for data that does not
exist in this database.

## Profit and market value

`npc_profit_per_hour` and `supply_cost_per_hour` use `loot_value_npc` and
`supplies_value`, which are populated whenever an item has a verified NPC
price (see `docs/systems/gameplay-analytics-supply-loot.md`). A separate
`market_loot_per_hour` column exists in `analytics_daily_vocation_metrics`
for `loot_value_market`, but the dashboard does not chart it by default
because this engine currently has no trustworthy Lua-accessible market price
source, so that column is always `0`. Add a market panel once (and only
once) a real market value integration exists.

## Import (ad hoc)

1. In Grafana, **Dashboards → New → Import**.
2. Upload `grafana/gameplay-analytics-dashboard.json` or paste its contents.
3. When prompted for the "Gameplay Analytics MariaDB" input, select (or
   create) a MySQL-type datasource pointed at your Canary database.
4. Import. Adjust the `vocation_id` / `hunt_area` / `server_version`
   variables from the values your own data contains.

## Provisioning (repeatable deployment)

1. Copy `grafana/provisioning/datasources/mariadb.yaml.example` to your
   Grafana provisioning directory as `mariadb.yaml`, fill in the real host
   and user, and supply the password out-of-band (an environment variable
   Grafana's provisioning loader substitutes, or your deployment tool's
   secret mechanism) — never a literal password in the file.
2. Copy `grafana/gameplay-analytics-dashboard.json` into the path referenced
   by `grafana/provisioning/dashboards/gameplay-analytics.yaml.example`
   (copy that file too, adjusting `options.path` to match).
3. Restart Grafana, or wait for `updateIntervalSeconds`.
4. Confirm the "Gameplay Analytics" folder and dashboard appear, and that
   panels populate (or show "No data" gracefully — see below — rather than
   erroring) against your real database.

## Upgrade

1. Re-run `schema/gameplay_analytics_views.sql`; every view uses
   `CREATE OR REPLACE VIEW`, so upgrading is repeatable and non-destructive.
2. Replace the provisioned `gameplay-analytics-dashboard.json` file with the
   new version. A file-provisioned dashboard is reloaded automatically within
   `updateIntervalSeconds`; a manually imported one must be re-imported.
3. Diff the new JSON's `templating.list` against the old one before
   replacing if you have made local edits in the Grafana UI — provisioned
   dashboards are read-only for structural changes made outside Grafana
   unless `allowUiUpdates: true` (as in the example) is set, in which case
   Grafana-side edits can be overwritten by the next provisioning reload.

## Empty datasets

Every view divides with `NULLIF(..., 0)`, so a group with zero
`combat_seconds` (or any other zero denominator) returns `NULL` for that
ratio instead of erroring. An empty table returns zero rows, not an error.
Grafana panels display "No data" for a zero-row result and blank cells for
`NULL` values; no panel in this dashboard requires non-empty data to render.

## Indexes and query cost

- `analytics_daily_vocation_metrics` / `analytics_daily_party_mode_metrics`
  filters on `vocation_id` and `session_date` use
  `analytics_daily_balance`'s primary key and
  `analytics_daily_balance_vocation_date` index.
- `analytics_session_drilldown` filters on `started_at` use the
  `analytics_sessions_started_id (started_at, id)` index added by
  `schema/gameplay_analytics_retention.sql`.
- `analytics_spell_efficiency_drilldown` joins on `analytics_sessions.id`
  (primary key) and `analytics_session_spells (session_id, spell_name)`
  (primary key).

`tools/analytics/test_gameplay_analytics_dashboard_views.sh` asserts (via
`EXPLAIN`) that the time-filtered queries above do not fall back to a full
table scan.
