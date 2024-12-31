function onUpdateDatabase()
	logger.info("Updating database to version 45 (feat: vip groups)")

	db.query([[
		CREATE TABLE IF NOT EXISTS `account_vipgroups` (
			`id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
			`account_id` int(11) UNSIGNED NOT NULL COMMENT 'id of account whose vip group entry it is',
			`name` varchar(128) NOT NULL,
			`customizable` BOOLEAN NOT NULL DEFAULT '1',
			CONSTRAINT `account_vipgroups_pk` PRIMARY KEY (`id`, `account_id`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

	db.query([[
		CREATE TRIGGER `oncreate_accounts` AFTER INSERT ON `accounts` FOR EACH ROW BEGIN
			INSERT INTO `account_vipgroups` (`account_id`, `name`, `customizable`) VALUES (NEW.`id`, 'Enemies', 0);
			INSERT INTO `account_vipgroups` (`account_id`, `name`, `customizable`) VALUES (NEW.`id`, 'Friends', 0);
			INSERT INTO `account_vipgroups` (`account_id`, `name`, `customizable`) VALUES (NEW.`id`, 'Trading Partner', 0);
		END;
	]])

	db.query([[
		CREATE TABLE IF NOT EXISTS `account_vipgrouplist` (
			`account_id` int(11) UNSIGNED NOT NULL COMMENT 'id of account whose viplist entry it is',
			`player_id` int(11) NOT NULL COMMENT 'id of target player of viplist entry',
			`vipgroup_id` int(11) UNSIGNED NOT NULL COMMENT 'id of vip group that player belongs',
			INDEX `account_id` (`account_id`),
			INDEX `player_id` (`player_id`),
			INDEX `vipgroup_id` (`vipgroup_id`),
			CONSTRAINT `account_vipgrouplist_unique` UNIQUE (`account_id`, `player_id`, `vipgroup_id`),
			CONSTRAINT `account_vipgrouplist_player_fk`
			FOREIGN KEY (`player_id`) REFERENCES `players` (`id`)
			ON DELETE CASCADE,
			CONSTRAINT `account_vipgrouplist_vipgroup_fk`
			FOREIGN KEY (`vipgroup_id`, `account_id`) REFERENCES `account_vipgroups` (`id`, `account_id`)
			ON DELETE CASCADE
		) ENGINE=InnoDB DEFAULT CHARSET=utf8;
	]])

	db.query([[
		INSERT INTO `account_vipgroups` (`id`, `account_id`, `name`, `customizable`)
		SELECT 1, id, 'Friends', 0 FROM `accounts`;
	]])

	db.query([[
		INSERT INTO `account_vipgroups` (`id`, `account_id`, `name`, `customizable`)
		SELECT 2, id, 'Enemies', 0 FROM `accounts`;
	]])

	db.query([[
		INSERT INTO `account_vipgroups` (`id`, `account_id`, `name`, `customizable`)
		SELECT 3, id, 'Trading Partners', 0 FROM `accounts`;
	]])
end
