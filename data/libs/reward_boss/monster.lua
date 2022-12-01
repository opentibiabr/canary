function Monster.setReward(self, enable)
	if enable then
		if not self:getType():isRewardBoss() then
			error("Rewards can only be enabled to rewards bosses.")
			return false
		end
		GlobalBosses[self:getId()] = {}
		self:registerEvent("BossDeath")
		self:registerEvent("BossThink")
	else
		GlobalBosses[self:getId()] = nil
		self:unregisterEvent("BossDeath")
		self:unregisterEvent("BossThink")
	end
	return true
end

-- For use of: data\events\scripts\monster.lua
function Monster:registerRewardBoss(corpse)
	local mType = self:getType()
	if mType:isRewardBoss() then
		corpse:registerReward()
		return
	end
end

function Monster:setRewardBoss()
	if self:getType():isRewardBoss() then
		self:setReward(true)
	end
end

function MonsterType.createLootItem(self, lootBlock, chance, lootTable)
	if lootTable == nil then
		lootTable = {}
	end
	local itemCount = 0
	local randvalue = math.random(0, 100000) / (configManager.getNumber(configKeys.RATE_LOOT) * chance)
	if randvalue < lootBlock.chance then
		if (ItemType(lootBlock.itemId):isStackable()) then
			itemCount = randvalue % lootBlock.maxCount + 1
		else
			itemCount = 1
		end
	end

	local itemType = ItemType(lootBlock.itemId)
	local decayTo = itemType:getDecayId()
	local decayTime = itemType:getDecayTime()
	if decayTo and decayTo >= 0 and decayTime and decayTime ~= 0 then
		local transformDeEquipId = itemType:getTransformDeEquipId()
		if transformDeEquipId and transformDeEquipId > 0 then
			Spdlog.warn("[MonsterType.createLootItem] - Convert boss '" .. self:name() .. "' reward ID '" .. lootBlock.itemId .. "' to ID " .. transformDeEquipId .. ".")
			lootBlock.itemId = transformDeEquipId
		else
			Spdlog.error("[MonsterType.createLootItem] Cannot add item " .. lootBlock.itemId .. " as boss " .. self:name() .. " reward. It has decay.")
			return lootTable
		end
	end

	local charges, n = itemType:getCharges()
	while itemCount > 0 do
		if charges > 0 then
			n = charges
			itemCount = itemCount - 1
		else
			n = math.min(itemCount, 100)
			itemCount = itemCount - n
		end

		table.insert(lootTable, {lootBlock.itemId, n})
	end

	return lootTable
end

function MonsterType.getBossReward(self, lootFactor, topScore)
	local result = {}
	if configManager.getNumber(configKeys.RATE_LOOT) > 0 then
		local loot = self:getLoot() or {}
		for i = #loot, 0, -1 do
			local lootBlock = loot[i]
			if lootBlock then
				if lootBlock.unique and not topScore then
					return
				else
					self:createLootItem(lootBlock, lootFactor, result)
				end
			end
		end
	end
	return result
end
