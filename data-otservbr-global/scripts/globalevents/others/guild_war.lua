local guildWar = GlobalEvent("guildwar")

function guildWar.onThink(interval)
	local time = os.time()
	db.query("UPDATE `guild_wars` SET `status` = 4 WHERE `status` = 1 AND `ended` < " .. time)
	return true
end

guildWar:interval(600000)
guildWar:register()
