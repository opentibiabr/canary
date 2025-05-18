local gravediggerChalk = Action()
function gravediggerChalk.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4637 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission27) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission28) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission28, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The flame wavers as it engulfs the chalk. Strange ashes appear beside it.")
		Game.createItem(19129, 1, Position(32983, 32376, 11))
		item:remove(1)
	end
	return true
end

gravediggerChalk:id(18930)
gravediggerChalk:register()
