local updateGuildWarStatus = GlobalEvent("UpdateGuildWarStatus")

function updateGuildWarStatus.onThink(interval)
	local currentTime = os.time()
	db.query(string.format("UPDATE `guild_wars` SET `status` = 4, `ended` = %d WHERE `status` = 1 AND `ended` != 0 AND `ended` < %d", currentTime, currentTime))
	return true
end

updateGuildWarStatus:interval(60000)
updateGuildWarStatus:register()
