local greenTear = Action()
function greenTear.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission02) ~= 1 then
		return true
	end

	Game.createItem(2346, 1, fromPosition)
	player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission02, 2)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a tear of daraman.")
	return true
end

greenTear:aid(5390)
greenTear:register()