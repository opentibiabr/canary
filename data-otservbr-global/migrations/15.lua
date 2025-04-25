function onUpdateDatabase()
	logger.info("Updating database to version 15 (Rook sample and GOD player values)")
	-- Rook Sample
	db.query("UPDATE `players` SET `maglevel` = 2, `manaspent` = 5936, `skill_club` = 12, `skill_club_tries` = 155, `skill_sword` = 12, `skill_sword_tries` = 155, `skill_axe` = 12, `skill_axe_tries` = 155, `skill_dist` = 12, `skill_dist_tries` = 93 WHERE `id` = 1;")
	-- GOD
	db.query("UPDATE `players` SET `health` = 155, `healthmax` = 155, `experience` = 100, `looktype` = 75, `town_id` = 8 WHERE `id` = 6;")
end
