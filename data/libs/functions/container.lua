function Container.isContainer(self)
	return true
end

---@alias LootItems table<number, {count: number, subType?: number, text?: string, actionId?: number, gut?: boolean, childLoot: LootItems}>

---@param loot LootItems
function Container:addLoot(loot)
	for itemId, item in pairs(loot) do
		local iType = ItemType(itemId)
		if not iType then
			logger.warn("Container:addLoot: invalid item type: {}", itemId)
			goto continue
		end
		if iType:isStackable() then
			local stackSize = iType:getStackSize()
			local remainingCount = item.count

			while remainingCount > 0 do
				local countToAdd = math.min(remainingCount, stackSize)
				local tmpItem = self:addItem(itemId, countToAdd, INDEX_WHEREEVER, FLAG_NOLIMIT)
				if not tmpItem then
					logger.warn("Container:addLoot: failed to add stackable item: {} with id {}, to corpse {} with id {}", ItemType(itemId):getName(), itemId, self:getName(), self:getId())
					goto continue
				end
				remainingCount = remainingCount - countToAdd
			end
		elseif iType:getCharges() ~= 0 then
			local tmpItem = self:addItem(itemId, item.count, INDEX_WHEREEVER, FLAG_NOLIMIT)
			if not tmpItem then
				logger.warn("Container:addLoot: failed to add charge item: {} with id {}, to corpse {} with id {}", ItemType(itemId):getName(), itemId, self:getName(), self:getId())
			end
		else
			for i = 1, item.count do
				local tmpItem = self:addItem(itemId, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
				if not tmpItem then
					logger.warn("Container:addLoot: failed to add item: {} with id {}, to corpse {} with id {}", ItemType(itemId):getName(), itemId, self:getName(), self:getId())
					goto continue
				end

				if tmpItem:isContainer() and item.childLoot then
					if not tmpItem:addLoot(item.childLoot) then
						tmpItem:remove()
						goto continue
					end
				end

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
			end
		end

		::continue::
	end
end

function Container:addRewardBossItems(itemList)
	for itemId, lootInfo in pairs(itemList) do
		local iType = ItemType(itemId)
		if iType then
			local itemCount = lootInfo.count
			local charges = iType:getCharges()
			if charges > 0 then
				itemCount = charges
				logger.debug("Adding item with 'id' to the reward container, item charges {}", iType:getId(), charges)
			end
			if iType:isStackable() or iType:getCharges() ~= 0 then
				self:addItem(itemId, itemCount, INDEX_WHEREEVER, FLAG_NOLIMIT)
			else
				for i = 1, itemCount do
					self:addItem(itemId, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
				end
			end
		end
	end
end
