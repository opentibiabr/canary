-- Gameplay Analytics reporting views for MariaDB 11.4+.
-- Safe to execute repeatedly (CREATE OR REPLACE VIEW).
--
-- Apply after schema/gameplay_analytics.sql, its migrations, and
-- schema/gameplay_analytics_retention.sql. These views back the Grafana
-- dashboard in grafana/gameplay-analytics-dashboard.json; see
-- docs/systems/gameplay-analytics-dashboards.md for the full explanation of
-- which view backs which panel and why.
--
-- Long-range dashboard panels query the two daily aggregate tables below.
-- Drill-down views further down read analytics_sessions / its detail tables
-- directly and are intended for bounded, recent-range queries only.

-- Daily performance metrics per vocation, level bracket, hunt area and
-- server version. One row per analytics_daily_balance row; every ratio is
-- computed here so dashboard panels never repeat the same division.
CREATE OR REPLACE VIEW `analytics_daily_vocation_metrics` AS
SELECT
    `session_date`,
    `server_version`,
    `hunt_area`,
    `vocation_id`,
    `level_bracket`,
    `source_sessions` AS `sessions`,
    `combat_seconds`,
    ROUND(`experience_raw` / NULLIF(`combat_seconds`, 0) * 3600) AS `exp_per_hour`,
    ROUND(`damage_dealt` / NULLIF(`combat_seconds`, 0)) AS `dps`,
    ROUND(`damage_received` / NULLIF(`combat_seconds`, 0)) AS `damage_taken_per_second`,
    ROUND(`healing_total` / NULLIF(`combat_seconds`, 0)) AS `healing_per_second`,
    ROUND(`deaths` / NULLIF(`source_sessions`, 0) * 100, 2) AS `deaths_per_100_sessions`,
    ROUND((`loot_value_npc` - `supplies_value`) / NULLIF(`combat_seconds`, 0) * 3600) AS `npc_profit_per_hour`,
    ROUND(`supplies_value` / NULLIF(`combat_seconds`, 0) * 3600) AS `supply_cost_per_hour`,
    ROUND(`loot_value_market` / NULLIF(`combat_seconds`, 0) * 3600) AS `market_loot_per_hour`,
    ROUND(`party_size_weighted` / NULLIF(`party_weight_seconds`, 0), 2) AS `avg_party_size`,
    LEAST(100.00, ROUND(`shared_experience_seconds` / NULLIF(`combat_seconds`, 0) * 100, 2)) AS `shared_experience_percent`
FROM `analytics_daily_balance`;

-- Solo versus party performance from a dedicated aggregate whose grouping
-- includes party_mode at raw-session classification time. This prevents one
-- daily row containing a mixture of solo and party sessions from being
-- labelled entirely as party because its average party size is above one.
CREATE OR REPLACE VIEW `analytics_daily_party_mode_metrics` AS
SELECT
    `session_date`,
    `server_version`,
    `hunt_area`,
    `vocation_id`,
    `level_bracket`,
    `party_mode` AS `mode`,
    `source_sessions` AS `sessions`,
    `combat_seconds`,
    ROUND(`experience_raw` / NULLIF(`combat_seconds`, 0) * 3600) AS `exp_per_hour`,
    ROUND((`loot_value_npc` - `supplies_value`) / NULLIF(`combat_seconds`, 0) * 3600) AS `npc_profit_per_hour`
FROM `analytics_daily_party_balance`;

-- Dead-letter queue health. Backed by the persisted dead-letter table, so
-- this is real MariaDB data rather than a snapshot of process-local
-- counters. Queue depth, retry-in-progress counts and flush duration are
-- process-local runtime counters with no MariaDB representation; they
-- remain available only through the in-game "/analytics status" command
-- (see docs/systems/gameplay-analytics-dashboards.md).
CREATE OR REPLACE VIEW `analytics_dead_letter_health` AS
SELECT
    COUNT(*) AS `pending_dead_letters`,
    COALESCE(MAX(`retry_count`), 0) AS `max_retry_count`,
    MAX(`failed_at`) AS `last_failure_at`,
    MIN(`failed_at`) AS `oldest_failure_at`
FROM `analytics_dead_letters`;

-- Drill-down: session-level fields for short, bounded ranges. Filters on
-- started_at can use analytics_sessions_started_id (started_at, id) from the
-- retention schema instead of scanning the table.
CREATE OR REPLACE VIEW `analytics_session_drilldown` AS
SELECT
    `id`,
    `started_at`,
    `vocation_id`,
    `level_start`,
    `hunt_area`,
    `server_version`,
    `party_size`,
    `combat_seconds`,
    `experience_raw`,
    `damage_dealt`,
    `damage_received`,
    `healing_self` + `healing_others` AS `healing_total`,
    `deaths`,
    `loot_value_npc`,
    `loot_value_market`,
    `supplies_value`
FROM `analytics_sessions`
WHERE `combat_seconds` >= 300;

-- Drill-down: spell efficiency. Spell aggregates only exist at raw-session
-- detail level, so bound panel queries by a started_at range.
CREATE OR REPLACE VIEW `analytics_spell_efficiency_drilldown` AS
SELECT
    `s`.`started_at`,
    `s`.`vocation_id`,
    `p`.`spell_name`,
    `p`.`casts`,
    `p`.`targets_hit`,
    `p`.`damage`,
    `p`.`healing`,
    `p`.`mana_spent`,
    `p`.`critical_hits`
FROM `analytics_session_spells` `p`
JOIN `analytics_sessions` `s` ON `s`.`id` = `p`.`session_id`;
