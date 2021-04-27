local forgottenKnowledgeSecret = Action()
function forgottenKnowledgeSecret.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.actionid == 24877 then
		player:teleportTo(Position(32891, 31620, 10))
		return true
	end
	if not player:getItemById(26406, true) then
		return false
	end
	if player:getStorageValue(Storage.ForgottenKnowledge.SilverKey) < 1 or not player:getItemById(26401, true) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You don\'t have the fitting key.')
		return true
	end
	player:teleportTo(Position(32924, 31637, 14))
	return true
end

forgottenKnowledgeSecret:aid(24876,24877)
forgottenKnowledgeSecret:register()