function onUpdateDatabase()
	logger.info("Updating database to version 27 (bosstiary system)")
	db.query("ALTER TABLE `players` ADD `boss_points` int NOT NULL DEFAULT '0';")
	db.query([[
	CREATE TABLE IF NOT EXISTS `boosted_boss` (
		`boostname` TEXT,
		`date` varchar(250) NOT NULL DEFAULT '',
		`raceid` varchar(250) NOT NULL DEFAULT '',
		`looktype` int(11) NOT NULL DEFAULT "136",
		`lookfeet` int(11) NOT NULL DEFAULT "0",
		`looklegs` int(11) NOT NULL DEFAULT "0",
		`lookhead` int(11) NOT NULL DEFAULT "0",
		`lookbody` int(11) NOT NULL DEFAULT "0",
		`lookaddons` int(11) NOT NULL DEFAULT "0",
		`lookmount` int(11) DEFAULT "0",
		PRIMARY KEY (`date`)
	) AS SELECT 0 AS date, "default" AS boostname, 0 AS raceid]])

	db.query([[
	CREATE TABLE IF NOT EXISTS `player_bosstiary` (
		`player_id` int NOT NULL,
		`bossIdSlotOne` int NOT NULL DEFAULT 0,
		`bossIdSlotTwo` int NOT NULL DEFAULT 0,
		`removeTimes` int NOT NULL DEFAULT 1
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;]])
end
