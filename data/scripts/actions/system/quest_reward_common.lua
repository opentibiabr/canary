-- Common chest reward
-- You just need to add a new table in the data/startup/tables/chest.lua file
-- This script will pull everything from there

local AttributeTable = {
	[6013] = {
		text = [[
Hardek *
Bozo *
Sam ****
Oswald
Partos ***
Quentin *
Tark ***
Harsky ***
Stutch *
Ferumbras *
Frodo **
Noodles ****]]
	}
}

local achievementTable = {
	-- [chestUniqueId] = "Achievement name",
	-- Annihilator
	[6085] = "Annihilator",
	[6086] = "Annihilator",
	[6087] = "Annihilator",
	[6088] = "Annihilator"
}

local function playerAddItem(params, item)
	local player = params.player
	if not checkWeightAndBackpackRoom(player, params.weight, params.message) then
		return false
	end

	if params.key then
		local itemType = ItemType(params.itemid)
		-- 23763 Is key of Dawnport
		-- Needs independent verification because it cannot be set as "key" in items.xml
		-- Because it generate bug in the item description
		if itemType:isKey() or itemType:getId(23763) then
			-- If is key not in container, uses the "isKey = true" variable
			keyItem = player:addItem(params.itemid, params.count)
			keyItem:setActionId(params.storage)
		end
	else
		addItem = player:addItem(params.itemid, params.count)
		-- If the item is writeable, just put its unique and the text in the "AttributeTable"
		local attribute = AttributeTable[item.uid]
		if attribute then
			addItem:setAttribute(ITEM_ATTRIBUTE_TEXT, attribute.text)
		end
		local achievement = achievementTable[item.uid]
		if achievement then
			player:addAchievement(achievement)
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, params.message .. ".")
	player:setStorageValue(params.storage, 1)
	return true
end

local function playerAddContainerItem(params, item)
	local player = params.player

	local reward = params.containerReward
	if params.action then
		local itemType = ItemType(params.itemid)
		if itemType:isKey() then
			-- If is key inside container, uses the "keyAction" variable
			keyItem = reward:addItem(params.itemid, params.count)
			keyItem:setActionId(params.action)
		end
	end

	local achievement = achievementTable[item.uid]
	if achievement then
		player:addAchievement(achievement)
	end

	reward:addItem(params.itemid, params.count)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. getItemName(params.itemBagName) .. ".")
	player:setStorageValue(params.storage, 1)
	return true
end

local questReward = Action()

function questReward.onUse(player, item, fromPosition, itemEx, toPosition)
	local setting = ChestUnique[item.uid]
	if not setting then
		return true
	end

	if setting.weight then
		local message = "You have found a " .. getItemName(setting.container) .. "."

		local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
		if not backpack or backpack:getEmptySlots(true) < 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message .. " But you have no room to take it.")
			return true
		end
		if (player:getFreeCapacity() / 100) < setting.weight then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
			message .. ". Weighing " .. setting.weight .. " oz, it is too heavy for you to carry.")
			return true
		end
	end

	if player:getStorageValue(setting.storage) >= 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The ".. getItemName(setting.itemId) .. " is empty.")
		return true
	end

	local container = player:addItem(setting.container)
	for i = 1, #setting.reward do
		local itemid = setting.reward[i][1]
		local count = setting.reward[i][2]
		local itemDescriptions = getItemDescriptions(itemid)
		local itemArticle = itemDescriptions.article
		local itemName = itemDescriptions.name
		local itemBagName = setting.container
		local itemBag = container

		if not setting.container then
			local addItemParams = {
				player = player,
				itemid = itemid,
				count = count,
				weight = getItemWeight(itemid) * count,
				storage = setting.storage,
				key = setting.isKey
			}

			if count > 1 and ItemType(itemid):isStackable() then
				if (itemDescriptions.plural) then
					itemName = itemDescriptions.plural
				end
				addItemParams.message = "You have found " .. count .. " " .. itemName
			elseif ItemType(itemid):getCharges() > 0 then
				addItemParams.message = "You have found " .. itemArticle .. " " .. itemName
			else
				addItemParams.message = "You have found " .. itemArticle .. " " .. itemName
			end
			if not playerAddItem(addItemParams, item) then
				return true
			end
		end

		if setting.container then
			local addContainerItemParams = {
				player = player,
				itemid = itemid,
				count = count,
				weight = setting.weight,
				storage = setting.storage,
				action = setting.keyAction,
				itemBagName = itemBagName,
				containerReward = itemBag
			}

			if not playerAddContainerItem(addContainerItemParams, item) then
				return true
			end
		end
	end
	return true
end

for uniqueRange = 5000, 9000 do
	questReward:uid(uniqueRange)
end

for uniqueRange = 10000, 12000 do
	questReward:uid(uniqueRange)
end

questReward:register()
