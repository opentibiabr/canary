-- return a dictionary of itemId => { count, gut }
---@param config { factor: number, gut: boolean, filter?: fun(itemType: ItemType, unique: boolean): boolean }
---@return LootItems
function MonsterType:generateLootRoll(config, resultTable)
	if configManager.getNumber(configKeys.RATE_LOOT) <= 0 then
		return resultTable or {}
	end

	local monsterLoot = self:getLoot() or {}
	local factor = config.factor or 1.0
	local uniqueItems = {}

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
		if config.gut and iType:getType() == ITEM_TYPE_CREATUREPRODUCT then
			chance = math.ceil((chance * GLOBAL_CHARM_GUT) / 100)
		end

		local randValue = getLootRandom(factor)
		if randValue >= chance then
			goto continue
		end

		local count = 0
		if iType:isStackable() then
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
