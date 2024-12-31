function onUpdateDatabase()
	logger.info("Updating database to version 9 (Mount Colors and familiars)")
	db.query("ALTER TABLE `players` ADD `lookmountbody` tinyint(3) unsigned NOT NULL DEFAULT '0'")
	db.query("ALTER TABLE `players` ADD `lookmountfeet` tinyint(3) unsigned NOT NULL DEFAULT '0'")
	db.query("ALTER TABLE `players` ADD `lookmounthead` tinyint(3) unsigned NOT NULL DEFAULT '0'")
	db.query("ALTER TABLE `players` ADD `lookmountlegs` tinyint(3) unsigned NOT NULL DEFAULT '0'")
	db.query("ALTER TABLE `players` ADD `lookfamiliarstype` int(11) unsigned NOT NULL DEFAULT '0'")
end
