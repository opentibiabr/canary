local serverInfo = TalkAction("!serverinfo")

function serverInfo.onSay(player, words, param)
	local configRateSkill =  configManager.getNumber(configKeys.RATE_SKILL)
	local text = "Server Info: \n\n"
	.. "\nExp rate: x" .. configManager.getNumber(configKeys.RATE_EXPERIENCE)
	.. "\nExp rate stages: x" .. configManager.getNumber(configKeys.RATE_USE_STAGES)
	.. "\nSkill rate: x" .. configManager.getNumber(configKeys.RATE_SKILL)
	.. "\nMagic rate: x" .. configManager.getNumber(configKeys.RATE_MAGIC)
	.. "\nLoot rate: x" .. configManager.getNumber(configKeys.RATE_LOOT)
	.. "\nLevel to buy house " .. configManager.getNumber(configKeys.HOUSE_BUY_LEVEL)
	.. "\nProtection level: " .. configManager.getNumber(configKeys.PROTECTION_LEVEL)
	.. "\nWorldType: " .. configManager.getString(configKeys.WORLD_TYPE)
	.. "\nKills/day to red skull: " .. configManager.getNumber(configKeys.DAY_KILLS_TO_RED)
	.. "\nKills/week to red skull: " .. configManager.getNumber(configKeys.WEEK_KILLS_TO_RED)
	.. "\nKills/month to red skull: " .. configManager.getNumber(configKeys.MONTH_KILLS_TO_RED)
	.. "\nServer Save: " .. configManager.getString(configKeys.GLOBAL_SERVER_SAVE_TIME)
	player:showTextDialog(34266, text)
	return false
end

serverInfo:separator(" ")
serverInfo:register()
