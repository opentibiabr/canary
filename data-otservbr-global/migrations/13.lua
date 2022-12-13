function onUpdateDatabase()
	Spdlog.info("Updating database to version 14 (Fixed mana spent)")
    db.query("ALTER TABLE `players` CHANGE `manaspent` `manaspent` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0';")
	return true
end
