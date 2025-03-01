function onUpdateDatabase()
	logger.info("Updating database to version 50 (multiworld system)")

	db.query("SET FOREIGN_KEY_CHECKS=0;")

	db.query([[
		CREATE TABLE IF NOT EXISTS `worlds` (
			`id` int(3) UNSIGNED NOT NULL AUTO_INCREMENT,
			`name` varchar(80) NOT NULL,
			`type` enum('no-pvp','pvp','retro-pvp','pvp-enforced','retro-pvp-enforced') NOT NULL,
			`motd` varchar(255) NOT NULL DEFAULT '',
			`location` enum('Europe','North America','South America','Oceania') NOT NULL,
			`ip` varchar(15) NOT NULL,
			`port` int(5) UNSIGNED NOT NULL,
			`port_status` int(6) UNSIGNED NOT NULL,
			`creation` int(11) NOT NULL DEFAULT 0,
			CONSTRAINT `worlds_pk` PRIMARY KEY (`id`),
			CONSTRAINT `worlds_unique` UNIQUE (`name`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

	db.query("ALTER TABLE `server_config` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `server_config` DROP PRIMARY KEY;")
	db.query("ALTER TABLE `server_config` ADD PRIMARY KEY (`config`, `world_id`);")
	db.query("ALTER TABLE `server_config` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `players_online` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `players_online` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `players` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `players` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `guilds` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `guilds` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `houses` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `houses` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `house_lists` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `house_lists` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `account_viplist` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `account_viplist` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `tile_store` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `tile_store` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `market_offers` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `market_offers` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `market_history` ADD `world_id` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `market_history` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `server_config` DROP PRIMARY KEY")
	db.query("ALTER TABLE `server_config` ADD PRIMARY KEY (`world_id`, `config`);")

	db.query("ALTER TABLE `houses` CHANGE `id` `id` INT(11) NOT NULL;")
	db.query("ALTER TABLE `houses` DROP PRIMARY KEY;")
	db.query("ALTER TABLE `houses` ADD PRIMARY KEY (`id`, `world_id`);")
	db.query("ALTER TABLE `houses` CHANGE `id` `id` INT(11) NOT NULL AUTO_INCREMENT;")
	db.query("ALTER TABLE `houses` ADD FOREIGN KEY (`world_id`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("DROP TRIGGER `ondelete_players`;")
	db.query([[
		CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
    		UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id` AND `world_id` = OLD.`world_id`;
		END;
	]])

	db.query("SET FOREIGN_KEY_CHECKS=1;")
end
