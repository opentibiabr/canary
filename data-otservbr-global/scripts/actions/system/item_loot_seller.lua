-- rest of config (item prices) is under function, paste there your items list from npc
local config = {
	price_percent = 90, -- how many % of shop price player receive when sell by 'item seller'
	cash_to_bank = true, -- send money to bank, not add to player BP
}

local shopItems = {}
local itemLootSeller = Action()
function itemLootSeller.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if toPosition.x ~= 65535 and getDistanceBetween(player:getPosition(), toPosition) > 1 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "This item is too far away.")
		return true
	end

	local targetTile = Tile(toPosition)
	if targetTile then
		-- this is to prevent selling item that lays in house doors
		local targetHouse = targetTile:getHouse()
		if targetHouse then
			-- this blocks only selling items laying on house floor
			-- if player open BP that lays on house floor, he can sell items inside it
			player:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot sell items in house.")
			return true
		end
	end

	local itemEx = Item(target.uid)
	if not itemEx then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "This is not an item.")
		return true
	end

	if itemEx:getUniqueId() < 65535 or itemEx:getActionId() > 0 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "You cannot sell quest item.")
		return true
	end

	if not shopItems[itemEx.itemid] then
		player:sendTextMessage(MESSAGE_INFO_DESCR, "This is not sellable item.")
		return true
	end

	local itemCount = 1
	local itemType = ItemType(itemEx.itemid)
	if itemType:isStackable() then
		itemCount = itemEx.type
	end

	local itemName = itemEx:getName()
	local itemValue = math.ceil(shopItems[itemEx.itemid] * itemCount / 100 * config.price_percent)
	if itemValue > 0 then
		itemEx:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
		itemEx:remove()

		local message = "You sold " .. itemCount .. " " .. itemName .. " for " .. itemValue .. " gold coins."
		if config.cash_to_bank then
			player:setBankBalance(player:getBankBalance() + itemValue)
			message = message .. " Money was added to your bank account."
		else
			player:addMoney(itemValue)
		end
		player:sendTextMessage(MESSAGE_INFO_DESCR, message)
	else
		player:sendTextMessage(MESSAGE_INFO_DESCR, itemName .. " is worthless.")
	end

	return true
end

itemLootSeller:aid(24950)
itemLootSeller:register()

local shopModule = {}
function shopModule:addBuyableItemContainer() end
function shopModule:addBuyableItem() end
function shopModule:addSellableItem(names, itemid, cost, realName)
	shopItems[itemid] = cost
end

function shopModule:parseList(data)
	for item in string.gmatch(data, "[^;]+") do
		local i = 1
		local itemid = -1
		local cost = 0
		for temp in string.gmatch(item, "[^,]+") do
			if i == 2 then
				itemid = tonumber(temp)
			elseif i == 3 then
				cost = tonumber(temp)
			end
			i = i + 1
		end

		shopItems[itemid] = cost
	end
end

-- here paste list of items from NPC lua file
shopModule:addSellableItem({ "mace" }, 3286, 5, "mace")
shopModule:addSellableItem({ "hota" }, 2342, 500, "helmet of the ancients")

-- here paste list from .xml file
shopModule:parseList("crossbow,2455,150;bow,2456,130")
shopModule:parseList("knight armor, 2476, 10000")
