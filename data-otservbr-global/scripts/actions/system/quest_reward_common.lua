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
Noodles ****]],
	},
	[6112] = {
		text = [[
... the dream master retreated to the world behind the curtains of awareness, I can't reach him, now that the last hall of dreams is lost to the forces of evil.
I sealed Goshnar's grave so no one can enter the pits without knowing our secret.
I will try to retreat to Knightwatch Tower and wait for a dreamer in possession of the key.
So we can travel on one of the dream paths to a saver place to regroup and to plan a counter-attack.
I fear we have to recruit new members and we have only little time left to train them.
I hope Taciror will not waste our last forces in a futile attack on the Ruthless Seven.
Our order has never truly recovered from the losses in our war against Goshnar and his undead hordes.
Now that our leaders and best warriors have died in the attack on the demonic forces, we don't stand a chance against our enemies.
Our only hope is to gather new forces and to recapture the chamber of dreams.
Of course I know the right method to distract Hugo long enough to get past him.
The dream master is important to teach our recruits in the old ways and in the art of dreamwalking.
We need a leader for our cause and we need him badly. Headless we will fail and fall.
It is already uncertain who took the Nightmare Chronicles out of the pits and I have no idea where they are hidden.
They are fighting about power and influence but unity is the key to success. Our whole order is centred about unity.
All our rituals and procedures rooted on unity and sharing, they can't neglect that.
]],
	},
	[6183] = {
		text = [[
Looks like the fox is out!
More luck next time!
Signed:
the horned fox
]],
	},
}

local achievementTable = {
	-- [chestUniqueId] = "Achievement name",
	-- Annihilator
	[6085] = "Annihilator",
	[6086] = "Annihilator",
	[6087] = "Annihilator",
	[6088] = "Annihilator",
}

local function playerAddItem(params, item, rewardIndex)
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

local function playerAddContainerItem(params, item, rewardIndex)
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
		local attribute = AttributeTable[item.uid]
		if attribute and rewardItem then
			rewardItem:setAttribute(ITEM_ATTRIBUTE_TEXT, attribute.text)
		end
	end

	local achievement = achievementTable[item.uid]
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
			if not playerAddItem(addItemParams, item, i) then
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

			if not playerAddContainerItem(addContainerItemParams, item, i) then
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
