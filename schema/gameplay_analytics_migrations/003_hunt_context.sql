ALTER TABLE `analytics_sessions`
    ADD COLUMN IF NOT EXISTS `hunt_area` VARCHAR(128) DEFAULT NULL AFTER `server_version`,
    ADD COLUMN IF NOT EXISTS `party_size_min` SMALLINT UNSIGNED NOT NULL DEFAULT 1 AFTER `party_size`,
    ADD COLUMN IF NOT EXISTS `party_size_max` SMALLINT UNSIGNED NOT NULL DEFAULT 1 AFTER `party_size_min`,
    ADD COLUMN IF NOT EXISTS `party_size_avg` DECIMAL(6,2) UNSIGNED NOT NULL DEFAULT 1.00 AFTER `party_size_max`,
    ADD COLUMN IF NOT EXISTS `shared_experience_seconds` INT UNSIGNED NOT NULL DEFAULT 0 AFTER `shared_experience`,
    ADD COLUMN IF NOT EXISTS `shared_experience_ratio` DECIMAL(6,4) UNSIGNED NOT NULL DEFAULT 0.0000 AFTER `shared_experience_seconds`,
    ADD COLUMN IF NOT EXISTS `party_vocations` VARCHAR(128) DEFAULT NULL AFTER `shared_experience_ratio`,
    ADD INDEX IF NOT EXISTS `analytics_sessions_hunt_area_time` (`hunt_area`, `started_at`);
