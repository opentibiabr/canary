function onUpdateDatabase()
	logger.info("Updating database to version 13 (Fixed mana spent)")
	db.query("ALTER TABLE `players` CHANGE `manaspent` `manaspent` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0';")
end
