local data = {
	converterIds = {
		[28525] = 28526,
		[28526] = 28525,
	},

	coins = {
		[ITEM_GOLD_COIN] = ITEM_PLATINUM_COIN,
		[ITEM_PLATINUM_COIN] = ITEM_CRYSTAL_COIN,
	},
}

local function findAndConvertCoins(player, container, converter)
	for i = 0, container:getSize() - 1 do
		local item = container:getItem(i)
		if item:isContainer() then
			findAndConvertCoins(player, Container(item.uid), converter)
		else
			for fromId, toId in pairs(data.coins) do
				if item:getId() == fromId and item:getCount() == 100 then
					item:remove()
					if not (container:addItem(toId, 1)) then
						player:addItem(toId, 1)
					end

					converter:setAttribute(ITEM_ATTRIBUTE_CHARGES, converter:getAttribute(ITEM_ATTRIBUTE_CHARGES) - 1)
					return true
				end
			end
		end
	end
	return false
end

local function startConverter(playerId, converterItemId)
	local player = Player(playerId)
	if player then
		local converter = player:getItemById(converterItemId, true)
		if converter and converter:hasAttribute(ITEM_ATTRIBUTE_CHARGES) then
			local charges = converter:getAttribute(ITEM_ATTRIBUTE_CHARGES)
			if charges >= 1 then
				if player:getItemCount(ITEM_GOLD_COIN) >= 100 or player:getItemCount(ITEM_PLATINUM_COIN) >= 100 then
					findAndConvertCoins(player, player:getStoreInbox(), converter)
				end
				addEvent(startConverter, 300, playerId, converterItemId)
			else
				converter:remove(1)
			end
		end
	end
end

local magicGoldConverter = Action()

function magicGoldConverter.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(data.converterIds[item.itemid])
	item:decay()
	startConverter(player:getId(), 28526)
	return true
end

magicGoldConverter:id(28525, 28526)
magicGoldConverter:register()
