local callback = EventCallback()

function callback.playerOnRotateItem(player, item, position)
	if item:getActionId() == 100 then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return false
	end

	return true
end

callback:register()
