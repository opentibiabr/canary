function Monster.setReward(self, enable)
	if enable then
		if not self:getType():isRewardBoss() then
			error("Rewards can only be enabled to rewards bosses.")
			return false
		end
		_G.GlobalBosses[self:getId()] = {}
		self:registerEvent("BossDeath")
		self:registerEvent("BossThink")
	else
		_G.GlobalBosses[self:getId()] = nil
		self:unregisterEvent("BossDeath")
		self:unregisterEvent("BossThink")
	end
	return true
end

function Monster:setRewardBoss()
	if self:getType():isRewardBoss() then
		self:setReward(true)
	end
end

local equipmentBags = {
	BagYouCovetId,
	BagYouDesireId,
	PrimalBagId,
}

local function isEquipment(itemType)
	if table.contains(equipmentBags, itemType:getId()) then
		return true
	end
	local t = itemType:getType()
	local equipmentTypes = {
		ITEM_TYPE_ARMOR,
		ITEM_TYPE_AMULET,
		ITEM_TYPE_BOOTS,
		ITEM_TYPE_HELMET,
		ITEM_TYPE_LEGS,
		ITEM_TYPE_RING,
		ITEM_TYPE_SHIELD,
		ITEM_TYPE_AXE,
		ITEM_TYPE_CLUB,
		ITEM_TYPE_DISTANCE,
		ITEM_TYPE_SWORD,
		ITEM_TYPE_WAND,
		ITEM_TYPE_QUIVER,
	}
	return table.contains(equipmentTypes, t)
end

function MonsterType.getBossReward(self, lootFactor, topScore, equipmentOnly, lootTable)
	if configManager.getNumber(configKeys.RATE_LOOT) <= 0 then
		return lootTable or {}
	end

	return self:generateLootRoll({
		factor = lootFactor,
		gut = false,
		filter = function(itemType, unique)
			if unique and not topScore then
				return false
			end
			if equipmentOnly then
				return not unique and isEquipment(itemType)
			end
			return true
		end,
	}, lootTable)
end
