local skillMap = {
	club = SKILL_CLUB,
	sword = SKILL_SWORD,
	axe = SKILL_AXE,
	dist = SKILL_DISTANCE,
	shield = SKILL_SHIELD,
	fish = SKILL_FISHING,
}

local function getSkillId(skillName)
	return skillMap[skillName:match("^%a+")] or SKILL_FIST
end

local addSkill = TalkAction("/addskill")

function addSkill.onSay(player, words, param)
	-- Create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if #split < 2 then
		player:sendCancelMessage("Usage: /addskill <playername>, <skill or 'level'/'magic'>, [amount]")
		return true
	end

	local targetPlayerName = split[1]:trim()
	local targetPlayer = Player(targetPlayerName)

	if not targetPlayer then
		player:sendCancelMessage("Player not found.")
		return true
	end

	local skillParam = split[2]:trim()
	local skillIncreaseAmount = tonumber(split[3]) or 1
	local skillPrefix = skillParam:sub(1, 1)

	if skillPrefix == "l" then
		local targetNewLevel = targetPlayer:getLevel() + skillIncreaseAmount
		local targetNewExp = Game.getExperienceForLevel(targetNewLevel)
		local experienceToAdd = targetNewExp - targetPlayer:getExperience()
		local levelText = (skillIncreaseAmount > 1) and "levels" or "level"

		targetPlayer:addExperience(experienceToAdd, false)
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s to you.", player:getName(), skillIncreaseAmount, levelText))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s to player %s.", skillIncreaseAmount, levelText, targetPlayer:getName()))
	elseif skillPrefix == "m" then
		for _ = 1, skillIncreaseAmount do
			local requiredManaSpent = targetPlayer:getVocation():getRequiredManaSpent(targetPlayer:getBaseMagicLevel() + 1)
			targetPlayer:addManaSpent(requiredManaSpent - targetPlayer:getManaSpent(), true)
		end

		local magicText = (skillIncreaseAmount > 1) and "magic levels" or "magic level"
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s to you.", player:getName(), skillIncreaseAmount, magicText))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s to player %s.", skillIncreaseAmount, magicText, targetPlayer:getName()))
	else
		local skillId = getSkillId(skillParam)
		for _ = 1, skillIncreaseAmount do
			local requiredSkillTries = targetPlayer:getVocation():getRequiredSkillTries(skillId, targetPlayer:getSkillLevel(skillId) + 1)
			targetPlayer:addSkillTries(skillId, requiredSkillTries - targetPlayer:getSkillTries(skillId), true)
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
