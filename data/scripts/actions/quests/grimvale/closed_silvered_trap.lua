local grimValeClosed = Action()
function grimValeClosed.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if toPosition.x == CONTAINER_POSITION then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Use it on the ground to set the trap.')
		return true
	end
	if player:getPosition():getDistance(Position(33390, 31540, 11)) >= 30 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You may use it in the Feroxa\'s room.')
		return true
	end
	item:transform(24715)
	item:decay()
	toPosition:sendMagicEffect(CONST_ME_POFF)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The silvered trap has been set and cannot be removed from its current position.')
	return true
end

grimValeClosed:id(24730)
grimValeClosed:register()