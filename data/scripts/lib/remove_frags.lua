function removeFragsFromPlayer(player)
	local playerId = player:getGuid()
	player:remove()
	db.query("UPDATE `player_kills` SET `time` = 1 WHERE `player_id` = " .. playerId .. "")
	return true
end
