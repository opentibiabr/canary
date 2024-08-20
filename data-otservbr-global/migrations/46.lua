function onUpdateDatabase()
	logger.info("Updating database to version 47 (multiworld system)")

	db.query("SET FOREIGN_KEY_CHECKS=0;")

	db.query([[
		CREATE TABLE IF NOT EXISTS `worlds` (
			`id` int(3) UNSIGNED NOT NULL AUTO_INCREMENT,
			`name` varchar(255) NOT NULL,
			`type` varchar(12) NOT NULL,
			`ip` varchar(15) NOT NULL,
			`port` int(5) UNSIGNED NOT NULL,
			CONSTRAINT `worlds_pk` PRIMARY KEY (`id`),
			CONSTRAINT `worlds_unique` UNIQUE (`name`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

	db.query("ALTER TABLE `server_config` ADD `worldId` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `server_config` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `players_online` ADD `worldId` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `players_online` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `players` ADD `worldId` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `players` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `houses` ADD `worldId` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `houses` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `house_lists` ADD `worldId` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `house_lists` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `account_viplist` ADD `worldId` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `account_viplist` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `tile_store` ADD `worldId` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `tile_store` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `market_offers` ADD `worldId` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `market_offers` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `market_history` ADD `worldId` int(3) UNSIGNED NOT NULL DEFAULT 1;")
	db.query("ALTER TABLE `market_history` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("ALTER TABLE `server_config` DROP PRIMARY KEY")
	db.query("ALTER TABLE `server_config` ADD PRIMARY KEY (`worldId`, `config`);")

	db.query("ALTER TABLE `houses` CHANGE `id` `id` INT(11) NOT NULL;")
	db.query("ALTER TABLE `houses` DROP PRIMARY KEY;")
	db.query("ALTER TABLE `houses` ADD PRIMARY KEY (`id`, `worldId`);")
	db.query("ALTER TABLE `houses` CHANGE `id` `id` INT(11) NOT NULL AUTO_INCREMENT;")
	db.query("ALTER TABLE `houses` ADD FOREIGN KEY (`worldId`) REFERENCES `worlds` (`id`) ON DELETE CASCADE;")

	db.query("DROP TRIGGER `ondelete_players`;")
	db.query([[
		CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
    		UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id` AND `worldId` = OLD.`worldId`;
		END;
	]])

	db.query("SET FOREIGN_KEY_CHECKS=1;")

	return true
end
