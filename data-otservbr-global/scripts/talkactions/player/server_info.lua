local serverInfo = TalkAction("!serverinfo")

function serverInfo.onSay(player, words, param)
	local configRateSkill =  configManager.getNumber(configKeys.RATE_SKILL)
	local baseRate = player:getFinalBaseRateExperience()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Server Info:"
	.. "\nExp rate: " .. baseRate
	.. "\nSword Skill rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_SWORD), configRateSkill)
	.. "\nClub Skill rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_CLUB), configRateSkill)
	.. "\nAxe Skill rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_AXE), configRateSkill)
	.. "\nDistance Skill rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_DISTANCE), configRateSkill)
	.. "\nShield Skill rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_SHIELD), configRateSkill)
	.. "\nFist Skill rate: " .. getRateFromTable(skillsStages, player:getSkillLevel(SKILL_FIST), configRateSkill)
	.. "\nMagic rate: " .. getRateFromTable(magicLevelStages, player:getBaseMagicLevel(), configManager.getNumber(configKeys.RATE_MAGIC))
	.. "\nLoot rate: " .. configManager.getNumber(configKeys.RATE_LOOT))
	return false
end

serverInfo:separator(" ")
serverInfo:register()
