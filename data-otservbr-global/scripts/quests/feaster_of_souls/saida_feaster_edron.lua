local positions = {
	{stonePos = {x = 33876, y = 31884, z = 8}, tpPos = {x = 33220, y = 31704, z = 7}},
}

local stone = MoveEvent()

function stone.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	local newPos
	for _, info in pairs(positions) do
		if Position(info.stonePos) == position then
			newPos = Position(info.tpPos)
			break
		end
	end
	if newPos then
		player:teleportTo(newPos)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		newPos:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

stone:type("stepin")

stone:id(28907)

stone:register()