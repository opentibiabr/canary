local data = {
	converterIds = {
		[28525] = 28526,
		[28526] = 28525,
	},
	coins = {
		[ITEM_GOLD_COIN] = ITEM_PLATINUM_COIN,
		[ITEM_PLATINUM_COIN] = ITEM_CRYSTAL_COIN
	}
}

local function findItem(self, cylinder, converterItem)
	if cylinder == 0 then
		cylinder = self:getSlotItem(CONST_SLOT_BACKPACK)
		findItem(self, self:getSlotItem(CONST_SLOT_STORE_INBOX), converterItem)
	end

	if cylinder and cylinder:isContainer() then
		for i = 0, cylinder:getSize() - 1 do
			local item = cylinder:getItem(i)
			if item:isContainer() then
				if findItem(self, Container(item.uid), converterItem) then
					-- Breaks the recursion from going into the next items in this cylinder
					return true
				end
			else
				for fromid, toid in pairs(data.coins) do
					if item:getId() == fromid and item:getCount() == 100 then
						item:remove()
						if not cylinder:addItem(toid, 1) then
							player:addItem(toid, 1)
						end

						converterItem:setAttribute(ITEM_ATTRIBUTE_CHARGES, converterItem:getAttribute(ITEM_ATTRIBUTE_CHARGES) - 1)
						return true
					end
				end
			end
		end
		-- End of items in this cylinder, returning to parent cylinder or finishing iteration
		return false
	end
end

local function startConversion(playerId, itemId)
	local player = Player(playerId)
	if player ~= nil then
		local converting = addEvent(startConversion, 300, playerId, itemId)
		local item = player:getItemById(itemId,true)
		if player:getItemCount(itemId) >= 1 then
			if item:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
				local charges_n = item:getAttribute(ITEM_ATTRIBUTE_CHARGES)
				if charges_n >= 1 then
					if player:getItemCount(ITEM_GOLD_COIN) >= 100 or player:getItemCount(ITEM_PLATINUM_COIN) >= 100 then
						findItem(player, 0, item)
					end
				else
					item:remove(1)
					stopEvent(converting)
				end
			end
		else
			stopEvent(converting)
		end
	end
	return true
end

local magicGoldConverter = Action()

function magicGoldConverter.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(data.converterIds[item.itemId])
	item:decay()
	startConversion(player:getId(), 28526)
	return true
end

magicGoldConverter:id(28525, 28526)
magicGoldConverter:register()
