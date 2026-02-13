function onUpdateDatabase()
	logger.info("Updating database to version 55 (add monk sample player)")

	-- Update GOD player ID from 6 to 7
	db.query("UPDATE `players` SET `id` = 7 WHERE `id` = 6 AND `name` = 'GOD';")
	-- Insert Monk Sample player with ID 6
	db.query("INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `maglevel`, `mana`, `manamax`, `manaspent`, `town_id`, `conditions`, `cap`, `sex`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`) VALUES (6, 'Monk Sample', 1, 1, 8, 9, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 90, 90, 0, 8, '', 470, 1, 10, 0, 10, 0, 10, 0, 10, 0) ON DUPLICATE KEY UPDATE `vocation` = 9, `level` = 8, `health` = 185, `healthmax` = 185, `experience` = 4200, `mana` = 90, `manamax` = 90;")
end
