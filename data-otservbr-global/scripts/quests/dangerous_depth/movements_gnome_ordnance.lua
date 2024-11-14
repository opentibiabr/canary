local gnomeOrdnance = MoveEvent()

function gnomeOrdnance.onStepIn(creature, position, fromPosition, toPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.DangerousDepths.Gnomes.Ordnance) == 1 then
		player:setStorageValue(Storage.DangerousDepths.Gnomes.Ordnance, 2)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You started an escort, get everyone to safety!")
	end
	return true
end

gnomeOrdnance:type("stepin")
gnomeOrdnance:aid(57241)
gnomeOrdnance:register()
