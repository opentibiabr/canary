-- Gameplay Analytics schema for Canary
-- Safe to execute repeatedly.
-- This file installs baseline schema version 1. Run the migration script after import.

CREATE TABLE IF NOT EXISTS `analytics_sessions` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `session_uuid` CHAR(36) NOT NULL,
    `player_id` INT NOT NULL,
    `player_name` VARCHAR(255) DEFAULT NULL,
    `vocation_id` SMALLINT UNSIGNED NOT NULL,
    `level_start` INT UNSIGNED NOT NULL,
    `level_end` INT UNSIGNED NOT NULL,
    `started_at` BIGINT UNSIGNED NOT NULL,
    `ended_at` BIGINT UNSIGNED NOT NULL,
    `duration_seconds` INT UNSIGNED NOT NULL,
    `combat_seconds` INT UNSIGNED NOT NULL DEFAULT 0,
    `experience_raw` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `experience_final` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `damage_dealt` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `damage_received` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `healing_self` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `healing_others` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `overhealing` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `mana_spent` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `monsters_killed` INT UNSIGNED NOT NULL DEFAULT 0,
    `deaths` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    `loot_value_npc` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `loot_value_market` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `supplies_value` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `party_size` SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    `shared_experience` TINYINT(1) NOT NULL DEFAULT 0,
    `detail_level` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `server_version` VARCHAR(64) DEFAULT NULL,
    `analytics_version` SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    PRIMARY KEY (`id`),
    UNIQUE KEY `analytics_sessions_uuid` (`session_uuid`),
    KEY `analytics_sessions_vocation_time` (`vocation_id`, `started_at`),
    KEY `analytics_sessions_player_time` (`player_id`, `started_at`),
    KEY `analytics_sessions_level` (`level_start`),
    CONSTRAINT `analytics_sessions_player_fk`
        FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `analytics_session_monsters` (
    `session_id` BIGINT UNSIGNED NOT NULL,
    `monster_name` VARCHAR(255) NOT NULL,
    `kills` INT UNSIGNED NOT NULL DEFAULT 0,
    `damage_dealt` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `damage_received` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `experience_raw` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`session_id`, `monster_name`),
    CONSTRAINT `analytics_monsters_session_fk`
        FOREIGN KEY (`session_id`) REFERENCES `analytics_sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `analytics_session_spells` (
    `session_id` BIGINT UNSIGNED NOT NULL,
    `spell_name` VARCHAR(255) NOT NULL,
    `casts` INT UNSIGNED NOT NULL DEFAULT 0,
    `targets_hit` INT UNSIGNED NOT NULL DEFAULT 0,
    `damage` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `healing` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `mana_spent` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `critical_hits` INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`session_id`, `spell_name`),
    CONSTRAINT `analytics_spells_session_fk`
        FOREIGN KEY (`session_id`) REFERENCES `analytics_sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `analytics_session_damage_types` (
    `session_id` BIGINT UNSIGNED NOT NULL,
    `damage_type` SMALLINT UNSIGNED NOT NULL,
    `damage_dealt` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `damage_received` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`session_id`, `damage_type`),
    CONSTRAINT `analytics_damage_types_session_fk`
        FOREIGN KEY (`session_id`) REFERENCES `analytics_sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `analytics_session_supplies` (
    `session_id` BIGINT UNSIGNED NOT NULL,
    `item_id` INT UNSIGNED NOT NULL,
    `amount_used` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `unit_value` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `total_value` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`session_id`, `item_id`),
    CONSTRAINT `analytics_supplies_session_fk`
        FOREIGN KEY (`session_id`) REFERENCES `analytics_sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `analytics_session_loot` (
    `session_id` BIGINT UNSIGNED NOT NULL,
    `item_id` INT UNSIGNED NOT NULL,
    `amount` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `npc_value` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `market_value` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`session_id`, `item_id`),
    CONSTRAINT `analytics_loot_session_fk`
        FOREIGN KEY (`session_id`) REFERENCES `analytics_sessions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `analytics_dead_letters` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    `session_uuid` CHAR(36) NOT NULL,
    `player_id` INT NOT NULL,
    `player_name` VARCHAR(255) DEFAULT NULL,
    `retry_count` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    `last_error` VARCHAR(255) NOT NULL,
    `failed_at` BIGINT UNSIGNED NOT NULL,
    `started_at` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `ended_at` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `experience_raw` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `experience_final` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `damage_dealt` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `damage_received` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `healing_total` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `mana_spent` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `monsters_killed` INT UNSIGNED NOT NULL DEFAULT 0,
    `deaths` SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    `loot_value_npc` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `loot_value_market` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    `supplies_value` BIGINT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `analytics_dead_letters_uuid` (`session_uuid`),
    KEY `analytics_dead_letters_failed_at` (`failed_at`),
    KEY `analytics_dead_letters_player` (`player_id`, `failed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `analytics_schema_migrations` (
    `version` INT UNSIGNED NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    `checksum` CHAR(64) NOT NULL DEFAULT '',
    `applied_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `analytics_schema_migrations` (`version`, `name`, `checksum`)
VALUES (1, 'baseline', '')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);
