function onUpdateDatabase()
	logger.info("Updating database to version 55 (add monk sample player)")

	-- Check if Monk Sample already exists
	local resultId = db.storeQuery("SELECT `id` FROM `players` WHERE `name` = 'Monk Sample' LIMIT 1;")
	if resultId then
		logger.warn("Monk Sample player already exists, skipping migration")
		Result.free(resultId)
		return
	end

	-- Find the next available player ID
	local maxIdResult = db.storeQuery("SELECT MAX(`id`) as max_id FROM `players`;")
	local nextId = 1
	if maxIdResult then
		nextId = Result.getNumber(maxIdResult, "max_id") + 1
		Result.free(maxIdResult)
	end

	logger.info("Inserting Monk Sample player with ID: " .. nextId)

	-- Insert Monk Sample player with the next available ID
	db.query(string.format("INSERT INTO `players` (`id`, `name`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `maglevel`, `mana`, `manamax`, `manaspent`, `town_id`, `conditions`, `cap`, `sex`, `skill_club`, `skill_club_tries`, `skill_sword`, `skill_sword_tries`, `skill_axe`, `skill_axe_tries`, `skill_dist`, `skill_dist_tries`, `comment`) VALUES (%d, 'Monk Sample', 1, 1, 8, 9, 185, 185, 4200, 113, 115, 95, 39, 129, 0, 90, 90, 0, 8, '', 470, 1, 10, 0, 10, 0, 10, 0, 10, 0, '');", nextId))
end
