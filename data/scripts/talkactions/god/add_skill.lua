local function getSkillId(skillName)
	if skillName == "club" then
		return SKILL_CLUB
	elseif skillName == "sword" then
		return SKILL_SWORD
	elseif skillName == "axe" then
		return SKILL_AXE
	elseif skillName:sub(1, 4) == "dist" then
		return SKILL_DISTANCE
	elseif skillName:sub(1, 6) == "shield" then
		return SKILL_SHIELD
	elseif skillName:sub(1, 4) == "fish" then
		return SKILL_FISHING
	else
		return SKILL_FIST
	end
end

local addSkill = TalkAction("/addskill")

function addSkill.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters.")
		return true
	end

	local target = Player(split[1])
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	split[2] = split[2]:trimSpace()

	local count = 1
	if split[3] then
		count = tonumber(split[3])
	end

	local ch = split[2]:sub(1, 1)
	if ch == "l" or ch == "e" then
		targetLevel = target:getLevel() + count
		targetExp = Game.getExperienceForLevel(targetLevel)
		addExp = targetExp - target:getExperience()
		target:addExperience(addExp, false)
	elseif ch == "m" then
		for i = 1, count do
			target:addManaSpent(target:getVocation():getRequiredManaSpent(target:getBaseMagicLevel() + 1) - target:getManaSpent(), true)
		end
	else
		local skillId = getSkillId(split[2])
		for i = 1, count do
			target:addSkillTries(skillId, target:getVocation():getRequiredSkillTries(skillId, target:getSkillLevel(skillId) + 1) - target:getSkillTries(skillId), true)
		end
	end
	return true
end

addSkill:separator(" ")
addSkill:groupType("god")
addSkill:register()
