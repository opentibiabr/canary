local bloodGoblet = Action()

function bloodGoblet.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.BloodGoblet) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The pile of bones is empty.")
		return true
	end

	local goblet = player:addItem(8531, 1)
	if goblet then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a blood goblet.")
		player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.BloodGoblet, 1)
	end

	return true
end

bloodGoblet:uid(14052)
bloodGoblet:register()
