local gravediggerHallowed = Action()
function gravediggerHallowed.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4634 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission19) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission20) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission20, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The flames roar and eat the bone hungrily. The Dark Lord is satisfied with your gift")
		item:remove()
	end
	return true
end

gravediggerHallowed:id(19089)
gravediggerHallowed:register()
