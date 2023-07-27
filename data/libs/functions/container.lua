function Container.isContainer(self)
	return true
end

function Container.createLootItem(self, item, charm, modifier)
	if self:getEmptySlots() == 0 then
		Spdlog.warn(string.format("[Container:createLootItem] - Could not add loot item to ontainer id: %d because no more empty slots were available", self:getId()))
		return false
	end

	local itemCount = 0
	local randvalue = getLootRandom(modifier)
	local lootBlockType = ItemType(item.itemId)
	local chanceTo = item.chance

	if not lootBlockType then
		Spdlog.warn(string.format("[Container:createLootItem] - Could not add loot item to ontainer id: %d because item type was not found", self:getId(), item.itemId))
		return false
	end

	-- Bestiary charm bonus
	if charm and lootBlockType:getType() == ITEM_TYPE_CREATUREPRODUCT then
		chanceTo = math.ceil((chanceTo * GLOBAL_CHARM_GUT) / 100)
	end

	if randvalue < chanceTo then
		if lootBlockType:isStackable() then
			local maxc, minc = item.maxCount or 1, item.minCount or 1
			itemCount = math.max(0, randvalue % (maxc - minc + 1)) + minc
		else
			itemCount = 1
		end
	end

	if itemCount == 0 then
		return false
	end
	while (itemCount > 0) do
		local n = math.min(itemCount, 100)
		itemCount = itemCount - n

		local tmpItem = self:addItem(item.itemId, n)
		if not tmpItem then
			return false
		end

		if tmpItem:isContainer() then
			for i = 1, #item.childLoot do
				if not tmpItem:createLootItem(item.childLoot[i], charm) then
					tmpItem:remove()
					return false
				end
			end
		end

		if item.subType ~= -1 then
			tmpItem:transform(item.itemId, item.subType)
		elseif lootBlockType:isFluidContainer() then
			tmpItem:transform(item.itemId, 0)
		end

		if item.actionId ~= -1 then
			tmpItem:setActionId(item.actionId)
		end

		if item.text and item.text ~= "" then
			tmpItem:setText(item.text)
		end
	end
	return true
end
