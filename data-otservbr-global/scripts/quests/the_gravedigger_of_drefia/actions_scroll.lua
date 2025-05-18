local gravediggerScroll = Action()
function gravediggerScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission53) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission54) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission54, 1)
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission55, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Somebody left a card. It says: Looking for the scroll? Come find me. Take the stairs next to the students. Dorm.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

gravediggerScroll:aid(4662)
gravediggerScroll:register()
