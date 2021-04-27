local orcTeleport = MoveEvent()

function orcTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item:getPosition() == Position(33167, 31930, 12) then
		player:teleportTo(Position(33182, 31837, 15))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	elseif item:getPosition() == Position(33183, 31837, 15) then
		player:teleportTo(Position(33168, 31930, 12))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

orcTeleport:type("stepin")
orcTeleport:id(11798)
orcTeleport:register()
