local old_hirelingSkills = {
	BANKER = 1, -- 1<<0
	COOKING = 2, -- 1<<1
	STEWARD = 4, -- 1<<2
	TRADER = 8, -- 1<<3
}

local old_hirelingOutfits = {
	BANKER = 1, -- 1<<0
	COOKING = 2, -- 1<<1
	STEWARD = 4, -- 1<<2
	TRADER = 8, -- 1<<3 ...
	SERVANT = 16,
	HYDRA = 32,
	FERUMBRAS = 64,
	BONELORD = 128,
	DRAGON = 256,
}

local old_hirelingStorage = {
	SKILL = 28800,
	OUTFIT = 28900,
}

local function getOutfits(player)
	local flags = player:getStorageValue(old_hirelingStorage.OUTFIT)
	local outfits = {}
	if flags <= 0 then
		return outfits
	end
	for key, value in pairs(old_hirelingOutfits) do
		if hasBitSet(value, flags) then
			table.insert(outfits, key)
		end
	end
	return outfits
end

local function getSkills(player)
	local flags = player:getStorageValue(old_hirelingStorage.SKILL)
	local skills = {}
	if flags <= 0 then
		return skills
	end
	for key, value in pairs(old_hirelingSkills) do
		if hasBitSet(value, flags) then
			table.insert(skills, key)
		end
	end
	return skills
end

local function migrateHirelingData(player)
	if not player then
		return false
	end

	local outfits = getOutfits(player)
	local skills = getSkills(player)
	if #outfits == 0 and #skills == 0 then
		return true
	end
	logger.info("Migrating hireling data for player {}", player:getName())
	for _, outfit in pairs(outfits) do
		logger.debug("Enabling hireling outfit: {}", outfit)
		local outfit = HIRELING_OUTFITS[outfit]
		if outfit then
			local name = outfit[2]
			if name then
				player:enableHirelingOutfit(name)
			else
				logger.error("Invalid hireling outfit name: {}", outfit[1])
			end
		else
			logger.error("Invalid hireling outfit: {}", outfit)
		end
	end

	for _, skill in pairs(skills) do
		logger.debug("Enabling hireling skill: {}", skill)
		local skill = HIRELING_SKILLS[skill]
		if skill then
			local name = skill[2]
			if name then
				player:enableHirelingSkill(name)
			else
				logger.error("Invalid hireling skill name: {}", skill[1])
			end
		else
			logger.error("Invalid hireling skill: {}", skill)
		end
	end
end

local migration = Migration("20231128213158_move_hireling_data_to_kv")

function migration:onExecute()
	self:forEachPlayer(migrateHirelingData)
end

migration:register()
