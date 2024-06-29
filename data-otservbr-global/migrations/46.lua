function onUpdateDatabase()
	logger.info("Updating database to version 46 (update Fix: The Postman Missions Quest - player_storage values)")

	local storageKey = 51366
	local oldValue = 8
	local newValue = 9

	local result = db.query("SELECT `player_id` FROM `player_storage` WHERE `key` = " .. storageKey .. " AND `value` = " .. oldValue)
	if result:getID() ~= -1 then
		repeat
			local playerId = result:getDataInt("player_id")
			if playerId then
				db.query("UPDATE `player_storage` SET `value` = " .. newValue .. " WHERE `player_id` = " .. playerId .. " AND `key` = " .. storageKey)
				logger.info("Updated player ID: " .. playerId)
			end
		until not result:next()
		result:free()
	else
		logger.info("No player found with the specified value in player_storage.")
	end

	return true
end
