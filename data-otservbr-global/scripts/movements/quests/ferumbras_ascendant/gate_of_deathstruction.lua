local gateOfDeathstruction = MoveEvent()

function gateOfDeathstruction.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.FerumbrasAscension.Statue) < 1 then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		position.y = position.y + 2
		player:teleportTo(position)
		position:sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(Position(33414, 32379, 13))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		local gatePos = Position(33415, 32377, 13)
		gatePos:sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
		"You have performed the Blood Well Ritual and now are worthy to enter the lower tunnels.")
	end
	return true
end

gateOfDeathstruction:type("stepin")
gateOfDeathstruction:aid(53802)
gateOfDeathstruction:register()
