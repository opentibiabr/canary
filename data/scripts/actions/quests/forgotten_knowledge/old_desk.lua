local forgottenKnowledgeOldDesk = Action()
function forgottenKnowledgeOldDesk.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.ForgottenKnowledge.SilverKey) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already get an old silver key.')
		return true
	end
	if player:getStorageValue(Storage.ForgottenKnowledge.GirlPicture) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You find an old silver key inside of the drower.')
		player:addItem(26401, true, true)
		player:setStorageValue(Storage.ForgottenKnowledge.SilverKey, 1)
		return true
	end
	if player:getStorageValue(Storage.ForgottenKnowledge.OldDesk) >= 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already get an old note.')
		return true
	end
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'As you open the drower a ghostly apparition shortly appears hovering over the desk. You find an old note inside of the drower.')
	player:addItem(26399, true, true)
	player:setStorageValue(Storage.ForgottenKnowledge.OldDesk, 1)
	return true
end

forgottenKnowledgeOldDesk:aid(24875)
forgottenKnowledgeOldDesk:register()