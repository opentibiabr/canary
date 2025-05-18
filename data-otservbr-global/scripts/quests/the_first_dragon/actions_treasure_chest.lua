local UniqueTable = {
	[14001] = {
		name = "giant shimmering pearl",
		count = 1,
	},
	[14002] = {
		-- gold nugget,
		itemId = 3040,
		count = 2,
	},
	[14003] = {
		name = "blue crystal shard",
		count = 1,
	},
	[14004] = {
		name = "violet crystal shard",
		count = 1,
	},
	[14005] = {
		name = "green crystal splinter",
		count = 2,
	},
	[14006] = {
		-- red gem
		itemId = 3039,
		count = 1,
	},
	[14007] = {
		name = "onyx chip",
		count = 3,
	},
	[14008] = {
		name = "platinum coin",
		count = 3,
	},
	[14009] = {
		name = "red crystal fragment",
		count = 2,
	},
	[14010] = {
		name = "yellow gem",
		count = 1,
	},
	[14011] = {
		name = "talon",
		count = 3,
	},
	[14012] = {
		name = "white pearl",
		count = 2,
	},
	[14013] = {
		name = "gold ingot",
		count = 1,
	},
	[14014] = {
		name = "opal",
		count = 3,
	},
	[14015] = {
		name = "small diamond",
		count = 2,
	},
	[14016] = {
		name = "green crystal shard",
		count = 1,
	},
	[14017] = {
		name = "black pearl",
		count = 3,
	},
	[14018] = {
		name = "emerald bangle",
		count = 1,
	},
	[14019] = {
		name = "green gem",
		count = 1,
	},
	[14020] = {
		name = "giant shimmering pearl",
		count = 1,
	},
}

local treasureChest = Action()

function treasureChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = UniqueTable[item.uid]
	if not setting then
		return false
	end

	local storageValue = player:getStorageValue(item.uid)
	if storageValue > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " .. item:getName() .. " is empty.")
		return true
	end

	if player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.ChestCounter) >= 19 then
		player:addAchievement("Treasure Hunter")
		player:addItem(setting.name or setting.itemId, setting.count, true)
		player:setStorageValue(item.uid, 1)
		player:setStorageValue(Storage.Quest.U11_02.TheFirstDragon.ChestCounter, player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.ChestCounter) + 1)
		return true
	end

	player:setStorageValue(item.uid, 1)
	player:setStorageValue(Storage.Quest.U11_02.TheFirstDragon.ChestCounter, player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.ChestCounter) + 1)

	if setting.name then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found " .. setting.count .. " " .. setting.name .. ".")
		player:addItem(setting.name, setting.count, true)
	elseif setting.itemId then
		player:addItem(setting.itemId, setting.count, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found " .. setting.count .. " " .. getItemName(setting.itemId) .. ".")
	end
	return true
end

for index, value in pairs(UniqueTable) do
	treasureChest:uid(index)
end

treasureChest:register()
