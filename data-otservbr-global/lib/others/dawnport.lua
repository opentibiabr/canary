dofile(CORE_DIRECTORY .. "/libs/functions/vocation.lua")

Dawnport = {
	skillsLimit = {
		[VOCATION.ID.NONE] = {},
		[VOCATION.ID.SORCERER] = {
			[SKILL_MAGLEVEL] = 20,
		},
		[VOCATION.ID.DRUID] = {
			[SKILL_MAGLEVEL] = 20,
		},
		[VOCATION.ID.PALADIN] = {
			[SKILL_MAGLEVEL] = 9,
		},
		[VOCATION.ID.KNIGHT] = {
			[SKILL_MAGLEVEL] = 4,
		},
		[VOCATION.ID.MONK] = {
			[SKILL_MAGLEVEL] = 5,
		},
	},
}

-- Change player vocation, converts magic level and skills between vocations and set proper stats
-- Used in dawnport vocation trial, Oressa and Inigo NPCs
function Player.changeVocation(self, newVocationId)
	-- Skip if change to same vocation
	if self:getVocation():getId() == newVocationId then
		return false
	end
	-- Get current vocation magic level and mana spent
	local magic = { level = self:getBaseMagicLevel(), manaSpent = self:getManaSpent() }
	-- Sum mana spent of every magic level
	for level = 1, magic.level do
		magic.manaSpent = magic.manaSpent + self:getVocation():getRequiredManaSpent(level)
	end
	local skills = {
		{ id = SKILL_FIST },
		{ id = SKILL_CLUB },
		{ id = SKILL_SWORD },
		{ id = SKILL_AXE },
		{ id = SKILL_DISTANCE },
		{ id = SKILL_SHIELD },
	}
	-- Get current vocation skills levels and skills tries
	for i = 1, #skills do
		skills[i].level = self:getSkillLevel(skills[i].id)
		skills[i].tries = self:getSkillTries(skills[i].id)
		-- Sum skill tries of every skill level
		for level = 11, skills[i].level do
			skills[i].tries = skills[i].tries + self:getVocation():getRequiredSkillTries(skills[i].id, level)
		end
	end
	-- Set new vocation
	self:setVocation(newVocationId)
	-- Convert magic level from previous vocation
	local newMagicLevel = 0
	if magic.manaSpent > 0 then
		local reqManaSpent = self:getVocation():getRequiredManaSpent(newMagicLevel + 1)
		while magic.manaSpent >= reqManaSpent do
			magic.manaSpent = magic.manaSpent - reqManaSpent
			newMagicLevel = newMagicLevel + 1
			reqManaSpent = self:getVocation():getRequiredManaSpent(newMagicLevel + 1)
		end
	end
	-- Apply magic level and/or mana spent
	if newMagicLevel > 0 then
		self:setMagicLevel(newMagicLevel, magic.manaSpent)
	elseif magic.manaSpent > 0 then
		self:addManaSpent(magic.manaSpent, true)
	end
	-- Convert skills from previous vocation
	for i = 1, #skills do
		local newSkillLevel = 10
		-- Calculate new level
		if skills[i].tries > 0 then
			local reqSkillTries = self:getVocation():getRequiredSkillTries(skills[i].id, (newSkillLevel + 1))
			while skills[i].tries >= reqSkillTries do
				skills[i].tries = skills[i].tries - reqSkillTries
				newSkillLevel = newSkillLevel + 1
				reqSkillTries = self:getVocation():getRequiredSkillTries(skills[i].id, (newSkillLevel + 1))
			end
		end
		-- Apply skill level and/or skill tries
		if newSkillLevel > 10 then
			self:setSkillLevel(skills[i].id, newSkillLevel, skills[i].tries)
		elseif skills[i].tries > 0 then
			self:addSkillTries(skills[i].id, skills[i].tries, true)
		end
	end
	-- Set health, mana and capacity stats based on the vocation if is higher than level 8
	if self:getLevel() > 8 then
		-- Base stats for level 1
		local stats = { health = 150, mana = 55, capacity = 40000 }
		-- No vocation
		if self:getVocation():getId() == VOCATION.ID.NONE then
			local level = self:getLevel() - 1
			stats.health = stats.health + (level * self:getVocation():getHealthGain())
			stats.mana = stats.mana + (level * self:getVocation():getManaGain())
			stats.capacity = stats.capacity + (level * self:getVocation():getCapacityGain())
			-- Main vocations
		else
			local baseLevel = 7
			local baseVocation = Vocation(VOCATION.ID.NONE)
			local level = self:getLevel() - 8
			stats.health = stats.health + (baseLevel * baseVocation:getHealthGain()) + (level * self:getVocation():getHealthGain())
			stats.mana = stats.mana + (baseLevel * baseVocation:getManaGain()) + (level * self:getVocation():getManaGain())
			stats.capacity = stats.capacity + (baseLevel * baseVocation:getCapacityGain()) + (level * self:getVocation():getCapacityGain())
		end
		self:setMaxHealth(stats.health)
		self:addHealth(stats.health)
		self:setMaxMana(stats.mana)
		self:addMana(stats.mana)
		self:setCapacity(stats.capacity)
	end
	return true
end

-- Checks if the skill growth is limited for a dawnport player
-- Used in onAdvance to notify and in onGainSkillTries to limit
function isSkillGrowthLimited(player, skillId)
	local town = player:getTown()
	-- Check that resides on dawnport
	if town and town:getId() == TOWNS_LIST.DAWNPORT then
		local vocationId = player:getVocation():getId()
		local skillsLimit = Dawnport.skillsLimit[vocationId]
		-- Check if there is set a skillId limit
		if skillsLimit and skillsLimit[skillId] then
			-- Get current skillId level
			local skillLevel
			if skillId == SKILL_MAGLEVEL then
				skillLevel = player:getBaseMagicLevel()
			else
				skillLevel = player:getSkillLevel(skillId)
			end
			-- Check skillId limit
			if skillLevel >= skillsLimit[skillId] then
				return true
			end
		end
	end
	return false
end

-- Removes from player inventory (equipped/containers) maindland smuggling items
function removeMainlandSmugglingItems(player)
	local smugglingItemIds = {
		3355, -- Leather helmet
		3562, -- Coat
		3559, -- Leather legs
		3552, -- Leather boots
		21348, -- The scorcher
		21350, -- The chiller
		21400, -- Spellbook of the novice
		3350, -- Bow
		3267, -- Dagger
		3412, -- Wooden shield
		35562, -- Quiver
		21470, -- Simple arrow
		266, -- Health potion
		268, -- Mana potion
		7876, -- Small health potion
		21352, -- Lightest missile rune
		21351, -- Light stone shower rune
	}
	for i = 1, #smugglingItemIds do
		local smugglingItemAmount = player:getItemCount(smugglingItemIds[i])
		if smugglingItemAmount > 0 then
			player:removeItem(smugglingItemIds[i], smugglingItemAmount)
		end
	end
end
