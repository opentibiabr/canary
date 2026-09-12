-- Shared reward execution. Configuration is supplied by the owning caller.
local function playerAddItem(params, item, rewardIndex, attribute, achievement)
	local player = params.player
	if not checkWeightAndBackpackRoom(player, params.weight, params.message) then
		return false
	end

	if params.key then
		local itemType = ItemType(params.itemid)
		-- 21392 Is key of Dawnport
		-- Needs independent verification because it cannot be set as "key" in items.xml
		-- Because it generate bug in the item description
		if itemType:isKey() or itemType:getId(21392) then
			-- If is key not in container, uses the "isKey = true" variab
			keyItem = player:addItem(params.itemid, params.count)
			keyItem:setActionId(params.storage)
		end
	else
		addItem = player:addItem(params.itemid, params.count)
		-- The caller supplies configuration-owned reward text.
		if attribute then
			addItem:setAttribute(ITEM_ATTRIBUTE_TEXT, attribute.text)
		end
		if achievement then
			player:addAchievement(achievement)
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, params.message .. ".")
	if params.useKV then
		player:questKV(params.questName):set("completed", true)
		if params.timer then
			player:questKV(params.questName):set("params.questName", os.time() + params.time * 3600) -- multiplicação por hora
		end
	else
		if params.storage == nil then
			logger.warn("Storage key is nil for reward index {}, itemid {}", rewardIndex, params.itemid)
			return false
		end

		player:setStorageValue(params.storage, 1)
		if params.timer then
			player:setStorageValue(params.timer, os.time() + params.time * 3600) -- multiplicação por hora
		end
	end
	return true
end

local function playerAddContainerItem(params, item, rewardIndex, attribute, achievement)
	local player = params.player

	local reward = params.containerReward
	local itemType = ItemType(params.itemid)
	if itemType:isKey() then
		keyItem = reward:addItem(params.itemid, params.count)
		if params.storage then
			keyItem:setActionId(params.action)
		end
	else
		local rewardItem = reward:addItem(params.itemid, params.count)
		if attribute and rewardItem then
			rewardItem:setAttribute(ITEM_ATTRIBUTE_TEXT, attribute.text)
		end
	end

	if achievement then
		player:addAchievement(achievement)
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. getItemName(params.itemBagName) .. ".")
	if params.useKV then
		player:questKV(params.questName):set("completed", true)
		if params.timer then
			player:questKV(params.questName):set("params.questName", os.time() + params.time * 3600) -- multiplicação por hora
		end
	else
		if params.storage == nil then
			logger.warn("Storage key is nil for reward index {}, itemid {} in container", rewardIndex, params.itemid)
			return false
		end

		player:setStorageValue(params.storage, 1)
		if params.timer then
			player:setStorageValue(params.timer, os.time() + params.time * 3600) -- multiplicação por hora
		end
	end
	return true
end

local function execute(player, item, setting, attribute, achievement)
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
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message .. ". Weighing " .. setting.weight .. " oz, it is too heavy for you to carry.")
			return true
		end
	end

	if setting.useKV then
		if player:questKV(setting.questName):get("completed") then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. getItemName(setting.itemId) .. " is empty.")
			return true
		end
		if setting.timerStorage and player:questKV(setting.questName):get("timer") and player:questKV(setting.questName):get("timer") > os.time() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. getItemName(setting.itemId) .. " is empty.")
			return true
		end
	else
		if player:getStorageValue(setting.storage) >= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. getItemName(setting.itemId) .. " is empty.")
			return true
		end
		if setting.timerStorage and player:getStorageValue(setting.timerStorage) > os.time() then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. getItemName(setting.itemId) .. " is empty.")
			return true
		end
	end

	if setting.randomReward then
		local randomReward = math.random(#setting.randomReward)
		setting.reward[1][1] = setting.randomReward[randomReward][1]
		setting.reward[1][2] = setting.randomReward[randomReward][2]
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
				key = setting.isKey,
				timer = setting.timerStorage,
				time = setting.time,
				questName = setting.questName,
				useKV = setting.useKV,
			}

			if count > 1 and ItemType(itemid):isStackable() then
				if itemDescriptions.plural then
					itemName = itemDescriptions.plural
				end
				addItemParams.message = "You have found " .. count .. " " .. itemName
			elseif ItemType(itemid):getCharges() > 0 then
				addItemParams.message = "You have found " .. itemArticle .. " " .. itemName
				if not ItemType(itemid):isRune() then
					addItemParams.weight = getItemWeight(itemid)
				end
			else
				addItemParams.message = "You have found " .. itemArticle .. " " .. itemName
			end
			if not playerAddItem(addItemParams, item, i, attribute, achievement) then
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
				containerReward = itemBag,
				questName = setting.questName,
				useKV = setting.useKV,
			}

			if not playerAddContainerItem(addContainerItemParams, item, i, attribute, achievement) then
				return true
			end
		end
	end

	return true
end

return execute
