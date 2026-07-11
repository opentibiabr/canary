-- Seeds the initial 3-channel topology for the docker/multichannel example
-- (see docs/multichannel/ARCHITECTURE.md). Runs once, after schema.sql, via
-- MariaDB's /docker-entrypoint-initdb.d mechanism (only on first container
-- creation against an empty data volume).
--
-- external_host/game_port/status_port are the HOST-published values (see
-- docker-compose.yml's port mappings), since that's what a client or the
-- login gateway's world list needs to advertise - not the in-container
-- port, which is the same 7171/7172/7173 for every channel since each
-- container has its own network namespace.

INSERT INTO `channels`
	(`id`, `name`, `pvp_type`, `external_host`, `game_port`, `status_port`, `max_players`, `enabled`, `sort_order`, `maintenance`, `maintenance_message`, `login_gateway`, `map_hash`, `created_at`, `updated_at`)
VALUES
	(1, 'Channel 1', 'no-pvp', '127.0.0.1', 7172, 7173, 0, 1, 0, 0, '', 1, '', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
	(2, 'Channel 2', 'no-pvp', '127.0.0.1', 8172, 8173, 0, 1, 1, 0, '', 0, '', UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),
	(3, 'Channel 3', 'pvp',    '127.0.0.1', 9172, 9173, 0, 1, 2, 0, '', 0, '', UNIX_TIMESTAMP(), UNIX_TIMESTAMP())
ON DUPLICATE KEY UPDATE
	`name` = VALUES(`name`),
	`pvp_type` = VALUES(`pvp_type`),
	`external_host` = VALUES(`external_host`),
	`game_port` = VALUES(`game_port`),
	`status_port` = VALUES(`status_port`),
	`updated_at` = UNIX_TIMESTAMP();
