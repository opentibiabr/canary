local roshamuulCarpet = MoveEvent()

function roshamuulCarpet.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local town = Town(TOWNS_LIST.THAIS)
	if not town then
		return true
	end

	local destination = town:getTemplePosition()
	player:teleportTo(destination)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The flying carpet brought you back to Thais.")
	position:sendMagicEffect(CONST_ME_POFF)
	destination:sendMagicEffect(CONST_ME_POFF)
	return true
end

roshamuulCarpet:type("stepin")
roshamuulCarpet:aid(4256)
roshamuulCarpet:register()
