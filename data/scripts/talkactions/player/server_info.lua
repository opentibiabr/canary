local serverInfo = TalkAction("!serverinfo")

function serverInfo.onSay(player, words, param)
	local text
	local useStages = configManager.getBoolean(configKeys.RATE_USE_STAGES)
	if not useStages then
		text = "Server Info Rates: \n"
			.. "\nExp rate: "
			.. configManager.getNumber(configKeys.RATE_EXPERIENCE)
			.. "x"
			.. "\nSkill rate: "
			.. configManager.getNumber(configKeys.RATE_SKILL)
			.. "x"
			.. "\nMagic rate: "
			.. configManager.getNumber(configKeys.RATE_MAGIC)
			.. "x"
			.. "\nLoot rate: "
			.. configManager.getNumber(configKeys.RATE_LOOT)
			.. "x"
			.. "\nSpawns rate: "
			.. configManager.getNumber(configKeys.RATE_SPAWN)
			.. "x"
	else
		local configRateSkill = configManager.getNumber(configKeys.RATE_SKILL)
		text = "Server Info Stages Rates: \n"
			.. "\nExp rate stages: "
			.. getRateFromTable(experienceStages, player:getLevel(), expstagesrate)
			.. "x"
			.. "\nSword Skill Stages rate: "
			.. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_SWORD), configRateSkill)
			.. "x"
			.. "\nClub Skill Stages rate: "
			.. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_CLUB), configRateSkill)
			.. "x"
			.. "\nAxe Skill Stages rate: "
			.. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_AXE), configRateSkill)
			.. "x"
			.. "\nDistance Skill Stages rate: "
			.. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_DISTANCE), configRateSkill)
			.. "x"
			.. "\nShield Skill Stages rate: "
			.. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_SHIELD), configRateSkill)
			.. "x"
			.. "\nFist Skill Stages rate: "
			.. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_FIST), configRateSkill)
			.. "x"
			.. "\nMagic rate: "
			.. getRateFromTable(magicLevelStages, player:getBaseMagicLevel(), configManager.getNumber(configKeys.RATE_MAGIC))
			.. "x"
			.. "\nLoot rate: "
			.. configManager.getNumber(configKeys.RATE_LOOT)
			.. "x"
			.. "\nSpawns rate: "
			.. configManager.getNumber(configKeys.RATE_SPAWN)
			.. "x"
	end
	local loseHouseText = configManager.getNumber(configKeys.HOUSE_LOSE_AFTER_INACTIVITY) > 0 and configManager.getNumber(configKeys.HOUSE_LOSE_AFTER_INACTIVITY) .. " days" or "never"
	text = text
		.. "\n\nMore Server Info: \n"
		.. "\nLevel to buy house: "
		.. configManager.getNumber(configKeys.HOUSE_BUY_LEVEL)
		.. "\nLose house after inactivity: "
		.. loseHouseText
		.. "\nProtection level: "
		.. configManager.getNumber(configKeys.PROTECTION_LEVEL)
		.. "\nWorldType: "
		.. configManager.getString(configKeys.WORLD_TYPE)
		.. "\nKills/day to red skull: "
		.. configManager.getNumber(configKeys.DAY_KILLS_TO_RED)
		.. "\nKills/week to red skull: "
		.. configManager.getNumber(configKeys.WEEK_KILLS_TO_RED)
		.. "\nKills/month to red skull: "
		.. configManager.getNumber(configKeys.MONTH_KILLS_TO_RED)
		.. "\nServer Save: "
		.. configManager.getString(configKeys.GLOBAL_SERVER_SAVE_TIME)
	player:showTextDialog(34266, text)
	return true
end

serverInfo:separator(" ")
serverInfo:groupType("normal")
serverInfo:register()
