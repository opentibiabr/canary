function onUpdateDatabase()
	logger.info("Updating database to version 59 (add multichannel cluster registry and audit tables)")

	if not db.tableExists("channels") then
		if
			not db.query([[
			CREATE TABLE `channels` (
				`id` int(11) NOT NULL,
				`name` varchar(64) NOT NULL,
				`pvp_type` enum('no-pvp','pvp','pvp-enforced') NOT NULL DEFAULT 'pvp',
				`external_host` varchar(255) NOT NULL DEFAULT '127.0.0.1',
				`game_port` int(11) NOT NULL,
				`status_port` int(11) NOT NULL,
				`max_players` int(11) NOT NULL DEFAULT '0',
				`enabled` tinyint(1) NOT NULL DEFAULT '1',
				`sort_order` int(11) NOT NULL DEFAULT '0',
				`temple_town_id` int(11) DEFAULT NULL,
				`maintenance` tinyint(1) NOT NULL DEFAULT '0',
				`maintenance_message` varchar(255) NOT NULL DEFAULT '',
				`login_gateway` tinyint(1) NOT NULL DEFAULT '0',
				`map_hash` varchar(64) NOT NULL DEFAULT '',
				`created_at` bigint(20) NOT NULL,
				`updated_at` bigint(20) NOT NULL,
				CONSTRAINT `channels_pk` PRIMARY KEY (`id`),
				CONSTRAINT `channels_name_unique` UNIQUE (`name`),
				CONSTRAINT `channels_endpoint_unique` UNIQUE (`external_host`, `game_port`),
				CONSTRAINT `channels_status_endpoint_unique` UNIQUE (`external_host`, `status_port`)
				-- temple_town_id deliberately has no FK to `towns`: InnoDB
				-- refuses to TRUNCATE a table that any other table has an
				-- incoming foreign key against, even with zero matching
				-- rows, which breaks existing world-reset/CI tooling that
				-- truncates `towns`. Enforced at the application layer
				-- (ChannelRegistry) instead - see schema.sql.
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		]])
		then
			logger.error("Failed to create channels table.")
			return false
		end
	else
		logger.warn("Table channels already exists, skipping creation")
	end

	if not db.tableExists("channel_runtime_status") then
		if
			not db.query([[
			CREATE TABLE `channel_runtime_status` (
				`channel_id` int(11) NOT NULL,
				`instance_id` varchar(64) NOT NULL DEFAULT '',
				`node_id` varchar(128) NOT NULL DEFAULT '',
				`started_at` bigint(20) NOT NULL DEFAULT '0',
				`last_heartbeat` bigint(20) NOT NULL DEFAULT '0',
				`status` enum('STARTING','ONLINE','DRAINING','MAINTENANCE','OFFLINE') NOT NULL DEFAULT 'STARTING',
				`players_online` int(11) NOT NULL DEFAULT '0',
				`build_sha` varchar(64) NOT NULL DEFAULT '',
				`map_hash` varchar(64) NOT NULL DEFAULT '',
				`data_hash` varchar(64) NOT NULL DEFAULT '',
				CONSTRAINT `channel_runtime_status_pk` PRIMARY KEY (`channel_id`),
				CONSTRAINT `channel_runtime_status_channel_fk`
					FOREIGN KEY (`channel_id`) REFERENCES `channels` (`id`)
					ON DELETE CASCADE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		]])
		then
			logger.error("Failed to create channel_runtime_status table.")
			return false
		end
	else
		logger.warn("Table channel_runtime_status already exists, skipping creation")
	end

	if not db.tableExists("cluster_sessions") then
		if
			not db.query([[
			CREATE TABLE `cluster_sessions` (
				`account_id` int(11) UNSIGNED NOT NULL,
				`player_id` int(11) NOT NULL,
				`channel_id` int(11) NOT NULL,
				`instance_id` varchar(64) NOT NULL DEFAULT '',
				`session_id` varchar(64) NOT NULL DEFAULT '',
				`fencing_token` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
				`status` enum('ACQUIRING','ONLINE','SAVING','DIRTY','OFFLINE') NOT NULL DEFAULT 'ACQUIRING',
				`acquired_at` bigint(20) NOT NULL DEFAULT '0',
				`last_heartbeat` bigint(20) NOT NULL DEFAULT '0',
				`expires_at` bigint(20) NOT NULL DEFAULT '0',
				CONSTRAINT `cluster_sessions_pk` PRIMARY KEY (`account_id`),
				CONSTRAINT `cluster_sessions_player_unique` UNIQUE (`player_id`),
				CONSTRAINT `cluster_sessions_account_fk`
					FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
					ON DELETE CASCADE,
				CONSTRAINT `cluster_sessions_player_fk`
					FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
					ON DELETE CASCADE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		]])
		then
			logger.error("Failed to create cluster_sessions table.")
			return false
		end
	else
		logger.warn("Table cluster_sessions already exists, skipping creation")
	end

	if not db.tableExists("channel_switch_audit") then
		if
			not db.query([[
			CREATE TABLE `channel_switch_audit` (
				`id` bigint(20) NOT NULL AUTO_INCREMENT,
				`player_id` int(11) NOT NULL,
				`account_id` int(11) UNSIGNED NOT NULL,
				`source_channel_id` int(11) DEFAULT NULL,
				`target_channel_id` int(11) NOT NULL,
				`source_position` varchar(64) NOT NULL DEFAULT '',
				`resolved_position` varchar(64) NOT NULL DEFAULT '',
				`fallback_reason` varchar(64) NOT NULL DEFAULT '',
				`session_id` varchar(64) NOT NULL DEFAULT '',
				`fencing_token` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
				`result` enum('SUCCESS','DENIED','ERROR') NOT NULL,
				`deny_reason` varchar(128) NOT NULL DEFAULT '',
				`created_at` bigint(20) NOT NULL,
				CONSTRAINT `channel_switch_audit_pk` PRIMARY KEY (`id`),
				INDEX `player_id` (`player_id`),
				INDEX `created_at` (`created_at`),
				CONSTRAINT `channel_switch_audit_player_fk`
					FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
					ON DELETE CASCADE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		]])
		then
			logger.error("Failed to create channel_switch_audit table.")
			return false
		end
	else
		logger.warn("Table channel_switch_audit already exists, skipping creation")
	end

	if not db.tableExists("economic_ledger") then
		if
			not db.query([[
			CREATE TABLE `economic_ledger` (
				`transaction_uuid` char(36) NOT NULL,
				`operation_type` varchar(64) NOT NULL,
				`account_id` int(11) UNSIGNED DEFAULT NULL,
				`player_id` int(11) DEFAULT NULL,
				`source_channel_id` int(11) DEFAULT NULL,
				`target_channel_id` int(11) DEFAULT NULL,
				`amount` bigint(20) NOT NULL DEFAULT '0',
				`currency` varchar(32) NOT NULL DEFAULT 'gold',
				`item_id` int(11) DEFAULT NULL,
				`item_count` int(11) DEFAULT NULL,
				`status` enum('PENDING','COMMITTED','FAILED','REPLAYED') NOT NULL DEFAULT 'PENDING',
				`session_id` varchar(64) NOT NULL DEFAULT '',
				`fencing_token` bigint(20) UNSIGNED NOT NULL DEFAULT '0',
				`created_at` bigint(20) NOT NULL,
				`updated_at` bigint(20) NOT NULL,
				CONSTRAINT `economic_ledger_pk` PRIMARY KEY (`transaction_uuid`),
				INDEX `operation_type` (`operation_type`),
				INDEX `account_id` (`account_id`),
				INDEX `created_at` (`created_at`)
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		]])
		then
			logger.error("Failed to create economic_ledger table.")
			return false
		end
	else
		logger.warn("Table economic_ledger already exists, skipping creation")
	end

	if not db.tableExists("mail_delivery_audit") then
		if
			not db.query([[
			CREATE TABLE `mail_delivery_audit` (
				`transaction_uuid` char(36) NOT NULL,
				`sender_player_id` int(11) DEFAULT NULL,
				`recipient_player_id` int(11) NOT NULL,
				`source_channel_id` int(11) DEFAULT NULL,
				`delivered_at` bigint(20) NOT NULL,
				CONSTRAINT `mail_delivery_audit_pk` PRIMARY KEY (`transaction_uuid`),
				INDEX `recipient_player_id` (`recipient_player_id`),
				CONSTRAINT `mail_delivery_audit_recipient_fk`
					FOREIGN KEY (`recipient_player_id`) REFERENCES `players` (`id`)
					ON DELETE CASCADE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		]])
		then
			logger.error("Failed to create mail_delivery_audit table.")
			return false
		end
	else
		logger.warn("Table mail_delivery_audit already exists, skipping creation")
	end

	if not db.tableExists("account_house_ownership") then
		if
			not db.query([[
			CREATE TABLE `account_house_ownership` (
				`account_id` int(11) UNSIGNED NOT NULL,
				`channel_id` int(11) NOT NULL,
				`house_id` int(11) NOT NULL,
				`since` bigint(20) NOT NULL,
				CONSTRAINT `account_house_ownership_pk` PRIMARY KEY (`account_id`),
				CONSTRAINT `account_house_ownership_house_unique` UNIQUE (`channel_id`, `house_id`),
				CONSTRAINT `account_house_ownership_account_fk`
					FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
					ON DELETE CASCADE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8;
		]])
		then
			logger.error("Failed to create account_house_ownership table.")
			return false
		end
	else
		logger.warn("Table account_house_ownership already exists, skipping creation")
	end

	-- Backfill current house owners (channel_id defaults to 1, the only channel that can exist pre-migration)
	db.query([[
		INSERT IGNORE INTO `account_house_ownership` (`account_id`, `channel_id`, `house_id`, `since`)
		SELECT `players`.`account_id`, 1, `houses`.`id`, UNIX_TIMESTAMP()
		FROM `houses`
		INNER JOIN `players` ON `players`.`id` = `houses`.`owner`
		WHERE `houses`.`owner` != 0;
	]])

	local marketOffersColumn = db.storeQuery("SHOW COLUMNS FROM `market_offers` LIKE 'source_channel_id';")
	if marketOffersColumn then
		logger.warn("Column market_offers.source_channel_id already exists, skipping")
		Result.free(marketOffersColumn)
	else
		if not db.query("ALTER TABLE `market_offers` ADD COLUMN `source_channel_id` int(11) DEFAULT NULL;") then
			logger.error("Failed to add market_offers.source_channel_id column.")
			return false
		end
	end

	local marketHistoryColumn = db.storeQuery("SHOW COLUMNS FROM `market_history` LIKE 'source_channel_id';")
	if marketHistoryColumn then
		logger.warn("Column market_history.source_channel_id already exists, skipping")
		Result.free(marketHistoryColumn)
	else
		if not db.query("ALTER TABLE `market_history` ADD COLUMN `source_channel_id` int(11) DEFAULT NULL;") then
			logger.error("Failed to add market_history.source_channel_id column.")
			return false
		end
	end

	local warKillsColumn = db.storeQuery("SHOW COLUMNS FROM `guildwar_kills` LIKE 'channel_id';")
	if warKillsColumn then
		logger.warn("Column guildwar_kills.channel_id already exists, skipping")
		Result.free(warKillsColumn)
	else
		if not db.query("ALTER TABLE `guildwar_kills` ADD COLUMN `channel_id` int(11) DEFAULT NULL;") then
			logger.error("Failed to add guildwar_kills.channel_id column.")
			return false
		end
	end

	return true
end
