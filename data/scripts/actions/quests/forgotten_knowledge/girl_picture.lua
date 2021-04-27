local forgottenKnowledgeGirl = Action()
function forgottenKnowledgeGirl.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.ForgottenKnowledge.GirlPicture) >= 1 then
		return false
	end
	player:setStorageValue(Storage.ForgottenKnowledge.GirlPicture, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Seems that an old silver key appears in the drower.')
	item:remove()
	return true
end

forgottenKnowledgeGirl:id(26400)
forgottenKnowledgeGirl:register()