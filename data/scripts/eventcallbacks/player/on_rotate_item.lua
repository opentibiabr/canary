local callback = EventCallback("PlayerOnRotateItemBaseEvent")

function callback.playerOnRotateItem(player, item, position)
	if item:getActionId() == IMMOVABLE_ACTION_ID then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	return true
end

callback:register()
