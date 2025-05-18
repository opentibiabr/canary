local gravediggerAshes = Action()
function gravediggerAshes.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4638 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission28) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission29) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission29, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The ashes swirl with a life of their own, mixing with the sparks of the altar.")
		item:remove(1)
	end
	return true
end

gravediggerAshes:id(19129)
gravediggerAshes:register()
