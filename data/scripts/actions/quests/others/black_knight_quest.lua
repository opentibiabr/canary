local othersBlackKnight = Action()
function othersBlackKnight.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.QuestChests.BlackKnightTreeKey) ~= 1 then
		local newItem = Game.createItem(2088, 1)
		newItem:setActionId(5010)
		player:addItemEx(newItem)
		player:setStorageValue(Storage.QuestChests.BlackKnightTreeKey, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a silver key.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The ' .. ItemType(item.itemid):getName() .. ' is empty.')
	end
end

othersBlackKnight:aid(5558)
othersBlackKnight:register()