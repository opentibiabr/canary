local config = {
	lesser = {
		names = {
			"lesser guardian gem",
			"lesser marksman gem",
			"lesser sage gem",
			"lesser mystic gem",
		},
		chance = {
			influenced = 9000,
			fiendish = 3000,
			archfoe = 0,
		},
		maxCount = 2,
	},
	regular = {
		names = {
			"guardian gem",
			"marksman gem",
			"sage gem",
			"mystic gem",
		},
		chance = {
			influenced = 0,
			fiendish = 3000,
			archfoe = 9000,
		},
		maxCount = 2,
	},
	greater = {
		names = {
			"greater guardian gem",
			"greater marksman gem",
			"greater sage gem",
			"greater mystic gem",
		},
		chance = {
			influenced = 0,
			fiendish = 9000,
			archfoe = 3000,
		},
		maxCount = 1,
	},
}

function Monster:generateGemAtelierLoot()
	local mType = self:getType()
	if not mType then
		return {}
	end
	local category = "none"
	local forgeClassification = self:getMonsterForgeClassification()
	if forgeClassification == FORGE_INFLUENCED_MONSTER then
		category = "influenced"
	elseif forgeClassification == FORGE_FIENDISH_MONSTER then
		category = "fiendish"
	elseif (mType:bossRace() or ""):lower() == "archfoe" then
		category = "archfoe"
	end
	if category == "none" then
		return {}
	end

	local loot = {}
	for _, gemConfig in pairs(config) do
		local chance = gemConfig.chance[category] or 0
		local names = gemConfig.names
		local maxCount = gemConfig.maxCount
		if chance > 0 then
			for i = 1, maxCount do
				local roll = math.random(1, 100000)
				if roll > chance then
					goto continue
				end

				local name = names[math.random(1, #names)]
				local itemType = ItemType(name)
				if not itemType then
					goto continue
				end
				if loot[itemType:getId()] then
					loot[itemType:getId()].count = loot[itemType:getId()].count + 1
				else
					loot[itemType:getId()] = { count = 1 }
				end
			end
		end
		::continue::
	end
	return loot
end
