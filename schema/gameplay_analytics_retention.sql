-- Optional Gameplay Analytics retention and daily aggregate schema.
-- Apply after schema/gameplay_analytics.sql and the main Analytics migrations.
-- Safe to execute repeatedly on MariaDB 11.4+.

CREATE TABLE IF NOT EXISTS `analytics_daily_balance` (
    `session_date` DATE NOT NULL,
    `server_version` VARCHAR(64) NOT NULL DEFAULT '',
    `hunt_area` VARCHAR(128) NOT NULL DEFAULT '',
    `vocation_id` SMALLINT UNSIGNED NOT NULL,
    `level_bracket` INT UNSIGNED NOT NULL,
    `source_sessions` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `combat_seconds` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `experience_raw` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `experience_final` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `damage_dealt` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `damage_received` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `healing_total` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `overhealing` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `mana_spent` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `monsters_killed` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `deaths` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `loot_value_npc` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `loot_value_market` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `supplies_value` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `party_size_weighted` DECIMAL(30,4) UNSIGNED NOT NULL DEFAULT 0,
    `party_weight_seconds` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `shared_experience_seconds` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`session_date`, `server_version`, `hunt_area`, `vocation_id`, `level_bracket`),
    KEY `analytics_daily_balance_vocation_date` (`vocation_id`, `session_date`),
    KEY `analytics_daily_balance_hunt_date` (`hunt_area`, `session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Separate aggregate for solo-versus-party reporting. Keeping party_mode in a
-- dedicated table avoids mixing solo and party sessions into one daily row
-- before the dashboard attempts to compare them.
CREATE TABLE IF NOT EXISTS `analytics_daily_party_balance` (
    `session_date` DATE NOT NULL,
    `server_version` VARCHAR(64) NOT NULL DEFAULT '',
    `hunt_area` VARCHAR(128) NOT NULL DEFAULT '',
    `vocation_id` SMALLINT UNSIGNED NOT NULL,
    `level_bracket` INT UNSIGNED NOT NULL,
    `party_mode` VARCHAR(8) NOT NULL,
    `source_sessions` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `combat_seconds` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `experience_raw` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `experience_final` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `damage_dealt` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `damage_received` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `healing_total` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `overhealing` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `mana_spent` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `monsters_killed` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `deaths` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `loot_value_npc` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `loot_value_market` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `supplies_value` DECIMAL(30,0) UNSIGNED NOT NULL DEFAULT 0,
    `party_size_weighted` DECIMAL(30,4) UNSIGNED NOT NULL DEFAULT 0,
    `party_weight_seconds` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `shared_experience_seconds` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`session_date`, `server_version`, `hunt_area`, `vocation_id`, `level_bracket`, `party_mode`),
    KEY `analytics_daily_party_vocation_date` (`vocation_id`, `session_date`),
    KEY `analytics_daily_party_mode_date` (`party_mode`, `session_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `analytics_maintenance_state` (
    `state_key` VARCHAR(64) NOT NULL,
    `value_date` DATE DEFAULT NULL,
    `value_bigint` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`state_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

ALTER TABLE `analytics_sessions`
    ADD INDEX IF NOT EXISTS `analytics_sessions_started_id` (`started_at`, `id`);
