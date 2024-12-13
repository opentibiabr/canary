local icon = TalkAction("/guild")

function icon.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local split = param:split(",")
	local category = split[1]
	local icon = split[2]

	local guild = player:getGuild()
	local guildId = tonumber(param)
	local otherGuild = Guild(guildId)
	otherGuild:addEnemy(player:getGuild():getId())
	guild:addEnemy(guildId)
	guild:updateEmblems()
	otherGuild:updateEmblems()
	return true
end

icon:separator(" ")
icon:groupType("normal")
icon:register()
