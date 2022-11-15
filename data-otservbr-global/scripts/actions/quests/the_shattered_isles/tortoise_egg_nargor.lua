local UniqueTable = {
	[14024] = {
		itemId = 6125,
		name = "tortoise egg from Nargor",
		count = 1
	}
}

local tortoiseEggNargor = Action()

function tortoiseEggNargor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local setting = UniqueTable[item.uid]
	if not setting then
		return true
	end

	if player:getStorageValue(Storage.TheShatteredIsles.TortoiseEggNargorTime) < os.time() then
			player:addItem(setting.name, setting.count, true)
			player:setStorageValue(Storage.TheShatteredIsles.TortoiseEggNargorTime, os.time() + 24 * 3600)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found " ..setting.count.. " " ..setting.name..".")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The " ..getItemName(setting.itemId).. " is empty.")
	end
	return true
end

tortoiseEggNargor:uid(14024)
tortoiseEggNargor:register()
