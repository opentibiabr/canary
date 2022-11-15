local forgottenKnowledgeFount = Action()
function forgottenKnowledgeFount.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.ForgottenKnowledge.Phial) >= 1 then
		return false
	end
	player:addItem(23810)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'A phial of fresh pond water. It looks crystal clear and sparkles a little.')
	player:setStorageValue(Storage.ForgottenKnowledge.Phial, 1)
	return true
end

forgottenKnowledgeFount:id(25135,25136,25137,25138)
forgottenKnowledgeFount:register()