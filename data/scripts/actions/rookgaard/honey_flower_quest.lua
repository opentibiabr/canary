local honeyFlowerQuest = Action()

function honeyFlowerQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.QuestChests.HoneyFlower) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The honeyflower patch is empty.')
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a honey flower.')
		player:addItem(2103, 1)
		player:setStorageValue(Storage.QuestChests.HoneyFlower, 1)
	end
	return true
end

honeyFlowerQuest:aid(5640)
honeyFlowerQuest:register()
