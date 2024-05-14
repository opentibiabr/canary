local serverInfo = TalkAction("!serverinfo")

function serverInfo.onSay(player, words, param)
	local text
	local useStages = configManager.getBoolean(configKeys.RATE_USE_STAGES)
	local isStaminaEnabled = configManager.getBoolean(configKeys.STAMINA_SYSTEM)
	local isStaminaActive = false
	if isStaminaEnabled then
		local staminaMinutes = player:getStamina()
		if staminaMinutes > 2340 and player:isPremium() then
			isStaminaActive = true
		end
	end
	if not useStages then
		text = "Hello! This are YOUR actual rates: \n"
			.. "\nExp rate: "
			.. configManager.getNumber(configKeys.RATE_EXPERIENCE) * (isStaminaActive and 1.5 or 1) * (SCHEDULE_EXP_RATE/100)
			.. "x"
			.. "\nSkill rate: "
			.. configManager.getNumber(configKeys.RATE_SKILL) * (isStaminaActive and 1.5 or 1) * (SCHEDULE_SKILL_RATE/100)
			.. "x"
			.. "\nMagic rate: "
			.. configManager.getNumber(configKeys.RATE_MAGIC) * (isStaminaActive and 1.25 or 1) * (SCHEDULE_SKILL_RATE/100)
			.. "x"
			.. "\nLoot rate: "
			.. configManager.getNumber(configKeys.RATE_LOOT) * (SCHEDULE_LOOT_RATE/100)
			.. "x"
	else
		local configRateSkill = configManager.getNumber(configKeys.RATE_SKILL)
		
		local SKILL_SWORD = player:getSkillLevel(SKILL_SWORD)
		local SKILL_CLUB = player:getSkillLevel(SKILL_CLUB)
		local SKILL_AXE = player:getSkillLevel(SKILL_AXE)
		local SKILL_DISTANCE = player:getSkillLevel(SKILL_DISTANCE)
		local SKILL_FIST = player:getSkillLevel(SKILL_FIST)
		
		local distance_multiplier = 1
		local main_skill_text = "Sword"
		local main_skill = SKILL_SWORD
		if SKILL_CLUB > main_skill then
			main_skill = SKILL_CLUB
			main_skill_text = "Club"
		end
		if SKILL_AXE > main_skill then
			main_skill = SKILL_AXE
			main_skill_text = "Axe"
		end
		if SKILL_DISTANCE > main_skill then
			main_skill = SKILL_DISTANCE
			main_skill_text = "Distance"
			distance_multiplier = 2
		end
		if SKILL_FIST > main_skill then
			main_skill = SKILL_FIST
			main_skill_text = "Fist"
		end
		
		text = "Hello! This are YOUR actual rates: \n"
			.. "\nExp rate: x"
			.. getRateFromTable(experienceStages, player:getLevel(), expstagesrate) * (isStaminaActive and 1.5 or 1)  * (SCHEDULE_EXP_RATE/100)

			.. "\nMagic rate: x"
			.. getRateFromTable(magicLevelStages, player:getBaseMagicLevel(), configManager.getNumber(configKeys.RATE_MAGIC)) * (isStaminaActive and 1.25 or 1) * (SCHEDULE_SKILL_RATE/100)

			.. "\n"..main_skill_text.." Skill rate: x"
			.. getRateFromTable(skillsStages, main_skill, configRateSkill) * (isStaminaActive and 1.5 or 1) * (SCHEDULE_SKILL_RATE/100) * distance_multiplier

			.. "\nShield Skill rate: x"
			.. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_SHIELD), configRateSkill) * (isStaminaActive and 1.5 or 1) * (SCHEDULE_SKILL_RATE/100)

			.. "\nLoot rate: x"
			.. configManager.getNumber(configKeys.RATE_LOOT) * (SCHEDULE_LOOT_RATE/100)

	end
	local loseHouseText = configManager.getNumber(configKeys.HOUSE_LOSE_AFTER_INACTIVITY) > 0 and configManager.getNumber(configKeys.HOUSE_LOSE_AFTER_INACTIVITY) .. " days" or "never"
	text = text
		.. "\n\nMore Server Info: \n"
		.. "\nSpawns rate: "
		.. configManager.getNumber(configKeys.RATE_SPAWN) * (SCHEDULE_SPAWN_RATE/100)
		.. "x"
		.. "\nLevel to buy house: "
		.. configManager.getNumber(configKeys.HOUSE_BUY_LEVEL)
		.. "\nLose house after inactivity: "
		.. loseHouseText
		.. "\nPVP Protection level: "
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
