local serverInfo = TalkAction("!serverinfo")

function serverInfo.onSay(player, words, param)
	local configRateSkill =  configManager.getNumber(configKeys.RATE_SKILL)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Server Info:"
	.. "\nExp rate: " .. getRateFromTable(experienceStages, player:getLevel(), configManager.getNumber(configKeys.RATE_EXP))
	.. "\nSword Skill rate: " .. getRateFromTable(skillsStages, player:getEffectiveSkillLevel(SKILL_SWORD), configRateSkill)
	.. "\nClub Skill rate: " .. getRateFromTable(skillsStages, player:getEffectiveSkillLevel(SKILL_CLUB), configRateSkill)
	.. "\nAxe Skill rate: " .. getRateFromTable(skillsStages, player:getEffectiveSkillLevel(SKILL_AXE), configRateSkill)
	.. "\nDistance Skill rate: " .. getRateFromTable(skillsStages, player:getEffectiveSkillLevel(SKILL_DISTANCE), configRateSkill)
	.. "\nShield Skill rate: " .. getRateFromTable(skillsStages, player:getEffectiveSkillLevel(SKILL_SHIELD), configRateSkill)
	.. "\nFist Skill rate: " .. getRateFromTable(skillsStages, player:getEffectiveSkillLevel(SKILL_FIST), configRateSkill)
	.. "\nMagic rate: " .. getRateFromTable(magicLevelStages, player:getMagicLevel(), configManager.getNumber(configKeys.RATE_MAGIC))
	.. "\nLoot rate: " .. configManager.getNumber(configKeys.RATE_LOOT))
	return false
end

serverInfo:separator(" ")
serverInfo:register()
