function onUpdateDatabase()
	logger.info("Updating database to version 1 (sample players)")
	-- Rook Sample
	db.query("UPDATE `players` SET `level` = 2, `vocation` = 0, `health` = 155, `healthmax` = 155, `experience` = 100, `soul` = 100, `lookbody` = 113, `lookfeet` = 115, `lookhead` = 95, `looklegs` = 39, `looktype` = 129, `mana` = 60, `manamax` = 60, `town_id` = 1, `cap` = 410 WHERE `id` = 1;")
	-- Sorcerer Sample
	db.query("UPDATE `players` SET `level` = 8, `vocation` = 1, `health` = 185, `healthmax` = 185, `experience` = 4200, `soul` = 100, `lookbody` = 113, `lookfeet` = 115, `lookhead` = 95, `looklegs` = 39, `looktype` = 129, `mana` = 90, `manamax` = 90, `town_id` = 8, `cap` = 470 WHERE `id` = 2;")
	-- Druid Sample
	db.query("UPDATE `players` SET `level` = 8, `vocation` = 2, `health` = 185, `healthmax` = 185, `experience` = 4200, `soul` = 100, `lookbody` = 113, `lookfeet` = 115, `lookhead` = 95, `looklegs` = 39, `looktype` = 129, `mana` = 90, `manamax` = 90, `town_id` = 8, `cap` = 470 WHERE `id` = 3;")
	-- Paladin Sample
	db.query("UPDATE `players` SET `level` = 8, `vocation` = 3, `health` = 185, `healthmax` = 185, `experience` = 4200, `soul` = 100, `lookbody` = 113, `lookfeet` = 115, `lookhead` = 95, `looklegs` = 39, `looktype` = 129, `mana` = 90, `manamax` = 90, `town_id` = 8, `cap` = 470 WHERE `id` = 4;")
	-- Knight Sample
	db.query("UPDATE `players` SET `level` = 8, `vocation` = 4, `health` = 185, `healthmax` = 185, `experience` = 4200, `soul` = 100, `lookbody` = 113, `lookfeet` = 115, `lookhead` = 95, `looklegs` = 39, `looktype` = 129, `mana` = 90, `manamax` = 90, `town_id` = 8, `cap` = 470 WHERE `id` = 5;")
end
