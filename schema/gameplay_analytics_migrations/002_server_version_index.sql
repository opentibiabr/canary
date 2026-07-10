ALTER TABLE `analytics_sessions`
    ADD INDEX IF NOT EXISTS `analytics_sessions_server_version_time` (`server_version`, `started_at`);
