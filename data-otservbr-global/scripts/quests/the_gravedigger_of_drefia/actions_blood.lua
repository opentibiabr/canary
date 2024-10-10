local config = {
	[4644] = { storageKey = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission36, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission36a }, message = "The blood in the vial is of a deep, ruby red.", itemId = 19101 },
	[4645] = { storageKey = { Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission36a, Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission37 }, message = "The blood in the vial is of a strange colour, as if tainted.", itemId = 19102 },
}

local gravediggerBlood = Action()
function gravediggerBlood.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.actionid]
	if not targetItem then
		return true
	end

	local cStorages = targetItem.storageKey
	if player:getStorageValue(cStorages[1]) == 1 and player:getStorageValue(cStorages[2]) < 1 then
		player:setStorageValue(cStorages[2], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetItem.message)
		player:addItem(targetItem.itemId, 1)
		item:remove(1)
	end
	return true
end

gravediggerBlood:id(19100)
gravediggerBlood:register()
