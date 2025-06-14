-- Enhanced skill map with all available skills
local skillMap = {
	club = SKILL_CLUB,
	sword = SKILL_SWORD,
	axe = SKILL_AXE,
	distance = SKILL_DISTANCE,
	shielding = SKILL_SHIELD,
	fishing = SKILL_FISHING,
	fist = SKILL_FIST,
}

-- Function to get skill ID from skill name
local function getSkillId(skillName)
	return skillMap[skillName:lower()]
end

-- Function to handle additive skill increase
local function addSkillLevels(player, skillId, levelsToAdd)
	local vocation = player:getVocation()
	local currentLevel = player:getSkillLevel(skillId)
	local currentTries = player:getSkillTries(skillId)
	local requiredTriesForCurrentNextLevel = vocation:getRequiredSkillTries(skillId, currentLevel + 1)

	local percent = 0
	if requiredTriesForCurrentNextLevel > 0 then
		percent = currentTries / requiredTriesForCurrentNextLevel
	end

	local newLevel = currentLevel + levelsToAdd
	local requiredTriesForNewNextLevel = vocation:getRequiredSkillTries(skillId, newLevel + 1)
	local newTries = math.floor(requiredTriesForNewNextLevel * percent)

	player:setSkillLevel(skillId, newLevel, newTries)
	return newLevel
end

-- Function to handle additive magic level increase
local function addMagicLevels(player, levelsToAdd)
	local vocation = player:getVocation()
	local currentLevel = player:getBaseMagicLevel()
	local currentManaSpent = player:getManaSpent()
	local requiredManaForCurrentNextLevel = vocation:getRequiredManaSpent(currentLevel + 1)

	local percent = 0
	if requiredManaForCurrentNextLevel > 0 then
		percent = currentManaSpent / requiredManaForCurrentNextLevel
	end

	local newLevel = currentLevel + levelsToAdd
	local requiredManaForNewNextLevel = vocation:getRequiredManaSpent(newLevel + 1)
	local newManaSpent = math.floor(requiredManaForNewNextLevel * percent)

	player:setMagicLevel(newLevel, newManaSpent)
	return player:getBaseMagicLevel()
end

local addSkill = TalkAction("/addskill")

function addSkill.onSay(player, words, param)
	-- Create log for admin actions
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		player:sendCancelMessage("Usage: /addskill <playername>, <skill or 'level'/'magic'>, <amount>")
		return true
	end

	local split = param:split(",")
	if #split < 3 then
		player:sendCancelMessage("Usage: /addskill <playername>, <skill or 'level'/'magic'>, <amount>")
		return true
	end

	-- Parse parameters
	local targetPlayerName = split[1]:trim()
	local targetPlayer = Player(targetPlayerName)

	if not targetPlayer then
		player:sendCancelMessage("Player not found.")
		return true
	end

	local skillParam = split[2]:trim():lower()
	local skillAmount = tonumber(split[3]:trim())

	if not skillAmount or skillAmount <= 0 then
		player:sendCancelMessage("Invalid amount. Must be a positive number.")
		return true
	end

	local skillPrefix = skillParam:sub(1, 1)

	-- Handle player level advancement
	if skillPrefix == "l" then
		local currentLevel = targetPlayer:getLevel()
		local newLevel = currentLevel + skillAmount
		local expForNewLevel = Game.getExperienceForLevel(newLevel)
		local expToAdd = expForNewLevel - targetPlayer:getExperience()
		if expToAdd > 0 then
			targetPlayer:addExperience(expToAdd, false)
		end
		local levelText = (skillAmount > 1) and "levels" or "level"
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s to you.", player:getName(), skillAmount, levelText))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s to player %s.", skillAmount, levelText, targetPlayer:getName()))

		-- Handle magic level advancement
	elseif skillPrefix == "m" then
		addMagicLevels(targetPlayer, skillAmount)
		local magicText = (skillAmount > 1) and "magic levels" or "magic level"
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s to you.", player:getName(), skillAmount, magicText))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s to player %s.", skillAmount, magicText, targetPlayer:getName()))

		-- Handle regular skill advancement
	else
		local skillId = getSkillId(skillParam)
		if not skillId then
			player:sendCancelMessage("Invalid skill name.")
			return true
		end
		addSkillLevels(targetPlayer, skillId, skillAmount)
		local skillText = (skillAmount > 1) and "skill levels" or "skill level"
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added %d %s %s to you.", player:getName(), skillAmount, skillParam, skillText))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added %d %s %s to player %s.", skillAmount, skillParam, skillText, targetPlayer:getName()))
	end

	return true
end

addSkill:separator(" ")
addSkill:groupType("god")
addSkill:register()

-- SETSKILL COMMAND
local setSkill = TalkAction("/setskill")

function setSkill.onSay(player, words, param)
	-- Create log for admin actions
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		player:sendCancelMessage("Usage: /setskill <playername>, <skill or 'level'/'magic'>, <exact_level>")
		return true
	end

	local split = param:split(",")
	if #split < 3 then
		player:sendCancelMessage("Usage: /setskill <playername>, <skill or 'level'/'magic'>, <exact_level>")
		return true
	end

	-- Parse parameters
	local targetPlayerName = split[1]:trim()
	local targetPlayer = Player(targetPlayerName)

	if not targetPlayer then
		player:sendCancelMessage("Player not found.")
		return true
	end

	local skillParam = split[2]:trim():lower()
	local skillAmount = tonumber(split[3]:trim())

	if not skillAmount or skillAmount < 0 then
		player:sendCancelMessage("Invalid level. Must be a positive number.")
		return true
	end

	local skillPrefix = skillParam:sub(1, 1)

	-- Handle player level setting
	if skillPrefix == "l" then
		local newLevel = tonumber(skillAmount)
		if newLevel <= 0 then
			player:sendCancelMessage("Invalid level.")
			return true
		end

		local currentLevel = targetPlayer:getLevel()
		if newLevel == currentLevel then
			player:sendCancelMessage("Player is already at that level.")
			return true
		end

		-- First, update the player's experience to match the new level
		local experience = Game.getExperienceForLevel(newLevel)
		if experience > targetPlayer:getExperience() then
			targetPlayer:addExperience(experience - targetPlayer:getExperience(), false)
		else
			targetPlayer:removeExperience(targetPlayer:getExperience() - experience, false)
		end

		-- Now, perform a full stat recalculation from base values (this is necessary because of levels 0 to 8 as no vocation)
		local vocation = targetPlayer:getVocation()

		-- Base stats at level 1
		local health = 150
		local mana = 55
		local capacity = 400

		-- Stat gains table (id, hp, mana, cap)
		local vocGains = {
			[0] = { 5, 5, 10 }, -- None
			[1] = { 5, 30, 10 }, -- Sorcerer
			[2] = { 5, 30, 10 }, -- Druid
			[3] = { 10, 15, 20 }, -- Paladin
			[4] = { 15, 5, 25 }, -- Knight
			[5] = { 5, 30, 10 }, -- Master Sorcerer
			[6] = { 5, 30, 10 }, -- Elder Druid
			[7] = { 10, 15, 20 }, -- Royal Paladin
			[8] = { 15, 5, 25 }, -- Elite Knight
		}

		local noVocGains = vocGains[0]
		local currentVocGains = vocGains[vocation:getId()] or noVocGains

		for i = 2, newLevel do
			if i <= 8 then
				health = health + noVocGains[1]
				mana = mana + noVocGains[2]
				capacity = capacity + noVocGains[3]
			else
				health = health + currentVocGains[1]
				mana = mana + currentVocGains[2]
				capacity = capacity + currentVocGains[3]
			end
		end

		-- Set final calculated stats
		targetPlayer:setMaxHealth(health)
		targetPlayer:addHealth(health - targetPlayer:getHealth())
		targetPlayer:setMaxMana(mana)
		targetPlayer:addMana(mana - targetPlayer:getMana())

		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, ("%s has set your level to %d."):format(player:getName(), newLevel))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, ("You have successfully set player %s level to %d."):format(targetPlayer:getName(), newLevel))
		return true
	end

	-- Handle magic level setting
	if skillPrefix == "m" then
		targetPlayer:setMagicLevel(skillAmount, 0)
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has set your magic level to %d.", player:getName(), skillAmount))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully set player %s magic level to %d.", targetPlayer:getName(), skillAmount))

		-- Handle regular skill setting
	else
		local skillId = getSkillId(skillParam)
		if not skillId then
			player:sendCancelMessage("Invalid skill name.")
			return true
		end
		targetPlayer:setSkillLevel(skillId, skillAmount, 0)
		targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has set your %s skill to level %d.", player:getName(), skillParam, skillAmount))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully set player %s %s skill to level %d.", targetPlayer:getName(), skillParam, skillAmount))
	end

	return true
end

setSkill:separator(" ")
setSkill:groupType("god")
setSkill:register()
