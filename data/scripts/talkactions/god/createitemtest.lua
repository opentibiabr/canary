local createLootTalkAction = TalkAction("/createloot")

local availableItems = {
	3347,
	3348,
	3349,
	3350,
	3351,
	3352,
	3353,
	3354,
	3355,
	3356,
	3357,
	3358,
	3359,
	3360,
	3361,
	3362,
}

-- Stackable items with chance and count range
local stackableItems = {
	{ id = 281, minCount = 10, maxCount = 25 }, -- giant shimmering pearl (green)
	{ id = 282, minCount = 10, maxCount = 35 }, -- giant shimmering pearl (brown)
	{ id = 3029, minCount = 50, maxCount = 100 }, -- small sapphire
	{ id = 3026, minCount = 50, maxCount = 90 }, -- white pearl
	{ id = 3033, minCount = 50, maxCount = 60 }, -- small amethyst
	{ id = 9057, minCount = 50, maxCount = 75 }, -- small topaz
}

function createLootTalkAction.onSay(player, words, param)
	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	if not inbox then
		player:sendCancelMessage("You don't have any store inbox.")
		return true
	end

	local lootPouch = nil
	for _, item in ipairs(inbox:getItems(true)) do
		if item:getId() == ITEM_GOLD_POUCH then
			lootPouch = item
			break
		end
	end

	if not lootPouch then
		player:sendCancelMessage("You don't have a Loot Pouch in your store inbox.")
		return true
	end

	local amount = tonumber(param)
	if not amount or amount <= 0 then
		player:sendCancelMessage("Please provide a valid number of items to create.")
		return true
	end

	local maxAmount = 10000
	if amount > maxAmount then
		player:sendCancelMessage("You can only create up to " .. maxAmount .. " items at once.")
		return true
	end

	local createdCount = 0
	for i = 1, amount do
		local isStackable = math.random(100) <= 30 -- 30% chance to pick stackable
		local itemId, itemCount

		if isStackable then
			local itemData = stackableItems[math.random(#stackableItems)]
			itemId = itemData.id
			itemCount = math.random(itemData.minCount, itemData.maxCount)
		else
			itemId = availableItems[math.random(#availableItems)]
			itemCount = 1
		end

		local item = Game.createItem(itemId, itemCount)
		if item then
			local flags = bit.bor(FLAG_NOLIMIT, FLAG_LOOTPOUCH)
			if lootPouch:addItemEx(item, INDEX_WHEREEVER, flags) ~= RETURNVALUE_NOERROR then
				item:remove()
				logger.warn("[/createloot] - Player: {} failed to add item {}, reason: {}", player:getName(), itemId, Game.getReturnMessage(RETURNVALUE_NOTENOUGHROOM))
				break
			end
			createdCount = createdCount + 1
		end
	end

	if createdCount > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, createdCount .. " items have been created in your Loot Pouch.")
		logger.info("[/createloot] - Player: " .. player:getName() .. " created " .. createdCount .. " items in their Loot Pouch.")
	else
		player:sendCancelMessage("Failed to create items in the Loot Pouch.")
		logger.error("[/createloot] - Player: " .. player:getName() .. " failed to create items in their Loot Pouch.")
	end

	return true
end

createLootTalkAction:separator(" ")
createLootTalkAction:groupType("god")
createLootTalkAction:register()

local clearStoreAction = TalkAction("/clearloot")

function clearStoreAction.onSay(player, words, param)
	local lootPouch = player:getLootPouch()
	if not lootPouch then
		player:sendCancelMessage("You don't have a Loot Pouch in your store inbox.")
		return true
	end

	local removedCount = lootPouch:removeAllItems(player)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, removedCount .. " items have been removed from your Loot Pouch.")
	logger.info("[/clearstore] - Player: " .. player:getName() .. " removed " .. removedCount .. " items from their Loot Pouch.")
	return true
end

clearStoreAction:separator(" ")
clearStoreAction:groupType("god")
clearStoreAction:register()

local createShopLootAction = TalkAction("/createtestshop")

function createShopLootAction.onSay(player, words, param)
	-- get the Store Inbox slot and the Loot Pouch inside it
	local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
	if not inbox then
		player:sendCancelMessage("You don't have any store inbox.")
		return true
	end

	local lootPouch
	for _, item in ipairs(inbox:getItems(true)) do
		if item:getId() == ITEM_GOLD_POUCH then
			lootPouch = item
			break
		end
	end
	if not lootPouch then
		player:sendCancelMessage("You don't have a Loot Pouch in your store inbox.")
		return true
	end

	local createdCount = 0

	local batchUpdate = BatchUpdate(player)
	batchUpdate:add(lootPouch)
	for _, cfg in ipairs(LootShopConfig) do
		local count = cfg.count or 1
		local item = Game.createItem(cfg.clientId, count)
		if item and item:getId() ~= ITEM_GOLD_POUCH then
			local flags = bit.bor(FLAG_NOLIMIT)
			local returnValue = lootPouch:addItemEx(item, INDEX_WHEREEVER, flags)
			if returnValue == RETURNVALUE_NOERROR then
				createdCount = createdCount + 1
				logger.debug("[/createtestshop] Player {} added {} x {} (id {})", player:getName(), count, cfg.itemName, cfg.clientId)
			else
				item:remove()
				logger.warn("[/createtestshop] Player {} failed to add {} (id {}), code: {}", player:getName(), cfg.itemName, cfg.clientId, Game.getReturnMessage(returnValue))
			end
		end
	end

	if createdCount > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, createdCount .. " item types have been created in your Loot Pouch.")
	else
		player:sendCancelMessage("No items could be created in the Loot Pouch.")
	end

	batchUpdate:delete()
	return true
end

createShopLootAction:separator(" ")
createShopLootAction:groupType("god")
createShopLootAction:register()

local countLootPouchAction = TalkAction("/countloot")

function countLootPouchAction.onSay(player, words, param)
	local lootPouch = player:getLootPouch()
	if not lootPouch then
		player:sendCancelMessage("You don't have a Loot Pouch in your store inbox.")
		return true
	end

	local totalStacks = #lootPouch:getItems(true)

	local totalCount = 0
	for _, item in ipairs(lootPouch:getItems(true)) do
		totalCount = totalCount + item:getCount()
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, ("Your Loot Pouch contains %d stacks, totaling %d items."):format(totalStacks, totalCount))

	return true
end

countLootPouchAction:separator(" ")
countLootPouchAction:groupType("god")
countLootPouchAction:register()

local addLootAction = TalkAction("/addloot")

local function trim(s)
	return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function resolveItemId(token)
	local id = tonumber(token)
	if id then
		return id
	end
	local it = ItemType(token)
	if it and it:getId() ~= 0 then
		return it:getId()
	end
	return nil
end

function addLootAction.onSay(player, words, param)
	param = trim(param or "")
	if param == "" then
		player:sendCancelMessage("Usage: /addloot <item name|id> [count]")
		return true
	end

	local lootPouch = player:getLootPouch()
	if not lootPouch then
		player:sendCancelMessage("You don't have a Loot Pouch in your store inbox.")
		return true
	end

	local namePart, countPart = param:match("^(.-)%s+(%d+)$")
	local token = namePart and trim(namePart) or param
	local count = tonumber(countPart) or 1
	if count <= 0 then
		count = 1
	end

	local itemId = resolveItemId(token)
	if not itemId or itemId == 0 then
		player:sendCancelMessage("Unknown item: " .. token)
		return true
	end
	if itemId == ITEM_GOLD_POUCH then
		player:sendCancelMessage("You can't create a Loot Pouch inside a Loot Pouch.")
		return true
	end

	local itype = ItemType(itemId)
	local name = itype and itype:getName() or ("item " .. itemId)
	local created = 0

	if itype and itype:isStackable() then
		local item = Game.createItem(itemId, count)
		local flags = bit.bor(FLAG_NOLIMIT, FLAG_LOOTPOUCH)
		if item and lootPouch:addItemEx(item, INDEX_WHEREEVER, flags) == RETURNVALUE_NOERROR then
			created = 1
		else
			if item then
				item:remove()
			end
		end
	else
		for i = 1, count do
			local item = Game.createItem(itemId, 1)
			if not item then
				break
			end
			local flags = bit.bor(FLAG_NOLIMIT, FLAG_LOOTPOUCH)
			if lootPouch:addItemEx(item, INDEX_WHEREEVER, flags) ~= RETURNVALUE_NOERROR then
				item:remove()
				break
			end
			created = created + 1
		end
	end

	if created == 0 then
		player:sendCancelMessage("Failed to create " .. name .. " in your Loot Pouch.")
	else
		if itype and itype:isStackable() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Added %dx %s to your Loot Pouch.", count, name))
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Added %dx %s to your Loot Pouch.", created, name))
		end
	end
	return true
end

addLootAction:separator(" ")
addLootAction:groupType("god")
addLootAction:register()
