local bigfootBeer = Action()
function bigfootBeer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.BigfootBurden.NeedsBeer) == 1 then
		player:setStorageValue(Storage.BigfootBurden.NeedsBeer, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Your mind feels refreshed!')
	end

	player:say("Gulp!", TALKTYPE_MONSTER_SAY)
	item:remove(1)
	return true
end

bigfootBeer:id(18305)
bigfootBeer:register()