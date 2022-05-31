local serverInfo = TalkAction("!serverinfo")

function serverInfo.onSay(player, words, param)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Server Info:"
	.. "\nExp rate: " .. getRateFromTable(experienceStages, player:getLevel(), configManager.getNumber(configKeys.RATE_EXPERIENCE))
	.. "\nSkill rate: " .. configManager.getNumber(configKeys.RATE_SKILL)
	.. "\nMagic rate: " .. configManager.getNumber(configKeys.RATE_MAGIC)
	.. "\nLoot rate: " .. configManager.getNumber(configKeys.RATE_LOOT))
	return false
end

serverInfo:separator(" ")
serverInfo:register()
