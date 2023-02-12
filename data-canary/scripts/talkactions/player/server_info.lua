local serverInfo = TalkAction("!serverinfo")

function serverInfo.onSay(player, words, param)
	local text = "Server Info:"
	.. "\nExp rate: " .. getRateFromTable(experienceStages, player:getLevel(), configManager.getNumber(configKeys.RATE_EXPERIENCE))
	.. "\nSkill rate: " .. configManager.getNumber(configKeys.RATE_SKILL)
	.. "\nMagic rate: " .. configManager.getNumber(configKeys.RATE_MAGIC)
	.. "\nLoot rate: " .. configManager.getNumber(configKeys.RATE_LOOT)

	local houseBuyLevel = configManager.getNumber(configKeys.HOUSE_BUY_LEVEL)
	if (houseBuyLevel ~= nil and player:getLevel() < houseBuyLevel) then
		text = text .. '\nLevel to buy house: ' .. houseBuyLevel
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, text)
	return false
end

serverInfo:separator(" ")
serverInfo:register()
