local serverInfo = TalkAction("!serverinfo")

function serverInfo.onSay(player, words, param)
	local configRateSkill =  configManager.getNumber(configKeys.RATE_SKILL)
	local text = "Server Info Rates: \n"
	.. "\nExp rate: x" .. configManager.getNumber(configKeys.RATE_EXPERIENCE)
	.. "\nSkill rate: x" .. configManager.getNumber(configKeys.RATE_SKILL)
	.. "\nMagic rate: x" .. configManager.getNumber(configKeys.RATE_MAGIC)
	.. "\nLoot rate: x" .. configManager.getNumber(configKeys.RATE_LOOT)
	.. "\nSpawns rate: x" .. configManager.getNumber(configKeys.RATE_SPAWN)
	text = text .. "\n"
	text = text .. "\n"
	text = text .. "Server Info Stages Rates: \n"
	.. "\nExp rate stages: x" .. configManager.getNumber(configKeys.RATE_USE_STAGES)
	.. "\nSword Skill Stages rate: x" .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_SWORD), configRateSkill)
	.. "\nClub Skill Stages rate: x" .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_CLUB), configRateSkill)
	.. "\nAxe Skill Stages rate: x" .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_AXE), configRateSkill)
	.. "\nDistance Skill Stages rate: x" .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_DISTANCE), configRateSkill)
	.. "\nShield Skill Stages rate: x" .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_SHIELD), configRateSkill)
	.. "\nFist Skill Stages rate: x" .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_FIST), configRateSkill)
	.. "\nMagic rate: x" .. getRateFromTable(magicLevelStages, player:getBaseMagicLevel(), configManager.getNumber(configKeys.RATE_MAGIC))
	.. "\nLoot rate: x" .. configManager.getNumber(configKeys.RATE_LOOT)
	.. "\nSpawns rate: x" .. configManager.getNumber(configKeys.RATE_SPAWN)
	text = text .. "\n"
	text = text .. "\n"
	text = text .. "More Server Info: \n"
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
