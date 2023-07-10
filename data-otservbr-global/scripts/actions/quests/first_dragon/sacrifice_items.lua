
local config = {
	[24939] = {storage = Storage.FirstDragon.Scale},
	[24940] = {storage = Storage.FirstDragon.Tooth},
	[24941] = {storage = Storage.FirstDragon.Horn},
	[24942] = {storage = Storage.FirstDragon.Bones}
}

local sacrificeItems = Action()

function sacrificeItems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = config[item.itemid]
	if not setting then
		return true
	end

	if player:getStorageValue(setting.storage) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already sacrificed this item to pass.")
		return true
	end

	if player:getStorageValue(Storage.FirstDragon.AccessCave) >= 4 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You\'re plunging " ..item:getName().. " into the lava. You are now worthy to enter The First Dragon's Lair. Touch the lava pool again.")
	return true
	end

	if player:getStorageValue(Storage.FirstDragon.AccessCave) < 0 then
		player:setStorageValue(Storage.FirstDragon.AccessCave, 0)
	end
	local targetPosition = Position(33047, 32712, 3)
	if (toPosition == targetPosition) then
		local targetId = Tile(targetPosition):getItemById(25160)
		if targetId then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You're plunging " ..item:getName().. " into the lava.")
			player:setStorageValue(Storage.FirstDragon.AccessCave, player:getStorageValue(Storage.FirstDragon.AccessCave) + 1)
			player:setStorageValue(setting.storage, 1)
			item:remove(1)
			return true
		end
	end
	return false
end

for itemId, itemInfo in pairs(config) do
	sacrificeItems:id(itemId)
end

sacrificeItems:register()