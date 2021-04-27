local data = {
	converterIds = {
		[32109] = 33299,
		[33299] = 32109,
		},
	coins = {
		[ITEM_GOLD_COIN] = ITEM_PLATINUM_COIN,
		[ITEM_PLATINUM_COIN] = ITEM_CRYSTAL_COIN
		}
}

local function finditem(self, cylinder, conv)
	if cylinder == 0 then
		cylinder = self:getSlotItem(CONST_SLOT_BACKPACK)
		finditem(self, self:getSlotItem(CONST_SLOT_STORE_INBOX), conv)
	end

	if cylinder and cylinder:isContainer() then
		for i = 0, cylinder:getSize() - 1 do
			local item = cylinder:getItem(i)
			if item:isContainer() then
				if finditem(self, Container(item.uid), conv) then
					-- Breaks the recursion from going into the next items in this cylinder
					return true
				end
			else
				for fromid, toid in pairs(data.coins) do
					if item:getId() == fromid and item:getCount() == 100 then						
						item:remove()
						if not(cylinder:addItem(toid, 1)) then
							player:addItem(toid, 1)
						end
						
						conv:setAttribute(ITEM_ATTRIBUTE_CHARGES, conv:getAttribute(ITEM_ATTRIBUTE_CHARGES) - 1)

						return true
					end
				end
			end
		end
		-- End of items in this cylinder, returning to parent cylinder or finishing iteration
		return false
	end
end

local function start_converter(pid, itemid)
	local player = Player(pid)
	if player ~= nil then
	
	local item = player:getItemById(itemid,true)
		if player:getItemCount(itemid) >= 1 then
			if item:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
				local charges_n = item:getAttribute(ITEM_ATTRIBUTE_CHARGES)
				if charges_n >= 1 then
					if player:getItemCount(ITEM_GOLD_COIN) >= 100 or player:getItemCount(ITEM_PLATINUM_COIN) >= 100 then
						finditem(player, 0, item)
					end
					local converting = addEvent(start_converter, 300, pid, itemid)
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
		item:transform(data.converterIds[item.itemid])
		item:decay()
		start_converter(player:getId(), 33299)
	return true
end

magicGoldConverter:id(32109, 33299)
magicGoldConverter:register()
