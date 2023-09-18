function Container.isContainer(self)
	return true
end

---@alias LootItems table<number, {count: number, subType?: number, text?: string, actionId?: number, gut?: boolean, childLoot: LootItems}>

---@param loot LootItems
function Container:addLoot(loot)
	for itemId, item in pairs(loot) do
		logger.debug("[Container:addLoot] - Adding loot item id: {} to container id: {}", itemId, self:getId())
		local tmpItem = self:addItem(itemId, item.count, INDEX_WHEREEVER, FLAG_NOLIMIT)
		if tmpItem then
			if tmpItem:isContainer() and item.childLoot then
				if not tmpItem:addLoot(item.childLoot) then
					tmpItem:remove()
					goto continue
				end
			end

			local iType = ItemType(itemId)
			if item.subType ~= -1 then
				tmpItem:transform(itemId, item.subType)
			elseif iType:isFluidContainer() then
				tmpItem:transform(itemId, 0)
			end

			if item.actionId ~= -1 then
				tmpItem:setActionId(item.actionId)
			end

			if item.text and item.text ~= "" then
				tmpItem:setText(item.text)
			end
		else
			logger.warn("Container:addLoot: failed to add item: {}, to corpse {} with id {}", ItemType(itemId):getName(), self:getName(), self:getId())
		end

		::continue::
	end
end
