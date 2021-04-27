local caveEntrance = MoveEvent()

function caveEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end
	local pos = item:getPosition()
	if pos.z == 5 then
		player:teleportTo(Position(33515, 31103, 8))
	elseif pos.z == 8 then
		player:teleportTo(Position(33334, 31151, 5))
	end
	player:setDirection(SOUTH)
	return true
end

caveEntrance:type("stepin")
caveEntrance:id(26403)
caveEntrance:register()
