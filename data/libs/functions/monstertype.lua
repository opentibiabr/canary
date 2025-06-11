-- return a dictionary of itemId => { count, gut }
---@param config { factor: number, gut: boolean, filter?: fun(itemType: ItemType, unique: boolean): boolean }
---@return LootItems
function MonsterType:generateLootRoll(config, resultTable, player)
	if configManager.getNumber(configKeys.RATE_LOOT) <= 0 then
		return resultTable or {}
	end

	local monsterLoot = self:getLoot() or {}
	local uniqueItems = {}

	local factor = config.factor or 1.0
	if self:isRewardBoss() then
		factor = factor * SCHEDULE_BOSS_LOOT_RATE / 100
	end

	local result = resultTable or {}
	for _, item in ipairs(monsterLoot) do
		local iType = ItemType(item.itemId)

		if config.filter and not config.filter(iType, item.unique) then
			goto continue
		end

		if uniqueItems[item.itemId] then
			goto continue
		end

		if not result[item.itemId] then
			result[item.itemId] = { count = 0, gut = false }
		end

		local chance = item.chance
		if SoulWarQuest and iType:getId() == SoulWarQuest.bagYouDesireItemId then
			result[item.itemId].chance = self:calculateBagYouDesireChance(player, chance)
			logger.debug("Final chance for bag you desire: {}, original chance: {}", result[item.itemId].chance, chance)
		end

		local dynamicFactor = factor * (math.random(95, 105) / 100)
		local adjustedChance = item.chance * dynamicFactor

		if config.gut and iType:getType() == ITEM_TYPE_CREATUREPRODUCT then
			adjustedChance = math.ceil((adjustedChance * GLOBAL_CHARM_GUT) / 100)
		end

		local randValue = getLootRandom()
		if randValue >= adjustedChance then
			goto continue
		end

		local count = 0
		local charges = iType:getCharges()
		if charges > 0 then
			count = charges
		elseif iType:isStackable() then
			local maxc, minc = item.maxCount or 1, item.minCount or 1
			count = math.max(0, randValue % (maxc - minc + 1)) + minc
		else
			count = 1
		end

		result[item.itemId].count = result[item.itemId].count + count
		result[item.itemId].gut = config.gut and iType:getType() == ITEM_TYPE_CREATUREPRODUCT
		result[item.itemId].unique = item.unique
		result[item.itemId].subType = item.subType
		result[item.itemId].text = item.text
		result[item.itemId].actionId = item.actionId

		if count > 0 and item.unique then
			uniqueItems[item.itemId] = true
		end

		::continue::
	end

	for itemId, item in pairs(result) do
		if item.count <= 0 then
			result[itemId] = nil
		end
	end

	return result
end
