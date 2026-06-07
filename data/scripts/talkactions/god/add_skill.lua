local skillMap = {
	fist = SKILL_FIST,
	club = SKILL_CLUB,
	sword = SKILL_SWORD,
	axe = SKILL_AXE,
	dist = SKILL_DISTANCE,
	distance = SKILL_DISTANCE,
	shield = SKILL_SHIELD,
	shielding = SKILL_SHIELD,
	fish = SKILL_FISHING,
	fishing = SKILL_FISHING,
}

local function getSkillId(skillName)
	return skillMap[skillName:lower():match("^%a+")] or SKILL_FIST
end

local addSkill = TalkAction("/addskill")

function addSkill.onSay(player, words, param)
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Usage: /addskill <playername>, <level|magic|skill>, [amount]")
		return true
	end

	local split = param:split(",")
	if #split < 2 then
		player:sendCancelMessage("Usage: /addskill <playername>, <level|magic|skill>, [amount]")
		return true
	end

	local targetPlayerName = split[1]:trim()
	local targetPlayer = Player(targetPlayerName)
	if not targetPlayer then
		player:sendCancelMessage("Player not found.")
		return true
	end

	local skillParam = split[2]:trim():lower()
	local skillIncreaseAmount = tonumber(split[3]) or 1

	if skillParam == "level" then
		local targetNewLevel = targetPlayer:getLevel() + skillIncreaseAmount
		local targetNewExp = Game.getExperienceForLevel(targetNewLevel)
		local experienceToAdd = targetNewExp - targetPlayer:getExperience()
		local levelText = (skillIncreaseAmount > 1) and "levels" or "level"

		targetPlayer:addExperience(experienceToAdd, false)
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s to you.", player:getName(), skillIncreaseAmount, levelText))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s to player %s.", skillIncreaseAmount, levelText, targetPlayer:getName()))
	elseif skillParam == "magic" then
		local currentML = targetPlayer:getBaseMagicLevel()
		local toAdd = 0

		for i = currentML + 1, currentML + skillIncreaseAmount do
			toAdd = toAdd + targetPlayer:getVocation():getRequiredManaSpent(i)
		end

		toAdd = toAdd - targetPlayer:getManaSpent()

		if toAdd > 0 then
			targetPlayer:addManaSpent(toAdd)
		end

		local magicText = (skillIncreaseAmount > 1) and "magic levels" or "magic level"
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s to you.", player:getName(), skillIncreaseAmount, magicText))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s to player %s.", skillIncreaseAmount, magicText, targetPlayer:getName()))
	else
		local skillId = getSkillId(skillParam)
		for _ = 1, skillIncreaseAmount do
			local currentLevel = targetPlayer:getSkillLevel(skillId)
			local required = targetPlayer:getVocation():getRequiredSkillTries(skillId, currentLevel + 1)
			local current = targetPlayer:getSkillTries(skillId)
			local toAdd = required - current
			if toAdd > 0 then
				targetPlayer:addSkillTries(skillId, toAdd, true)
			end
		end

		local skillText = (skillIncreaseAmount > 1) and "skill levels" or "skill level"
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s %s to you.", player:getName(), skillIncreaseAmount, skillParam, skillText))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s %s to player %s.", skillIncreaseAmount, skillParam, skillText, targetPlayer:getName()))
	end

	return true
end

addSkill:separator(" ")
addSkill:groupType("god")
addSkill:register()
