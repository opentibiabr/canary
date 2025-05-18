function onUpdateDatabase()
	logger.info("Updating database to version 4 (boosted creature)")
	db.query([[CREATE TABLE IF NOT EXISTS `boosted_creature` (
        `boostname` TEXT,
        `date` varchar(250) NOT NULL DEFAULT '',
        `raceid` varchar(250) NOT NULL DEFAULT '',
        PRIMARY KEY (`date`)
    ) AS SELECT 0 AS date, "default" AS boostname, 0 AS raceid]])
end
