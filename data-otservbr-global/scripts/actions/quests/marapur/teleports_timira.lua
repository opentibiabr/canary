local positions = {
	{ tptimiraPos = { x = 33803, y = 32700, z = 7 }, tpPos = { x = 33806, y = 32700, z = 8 } },

	{ tptimiraPos = { x = 33802, y = 32700, z = 8 }, tpPos = { x = 33804, y = 32702, z = 7 } },

	{ tptimiraPos = { x = 33816, y = 32710, z = 9 }, tpPos = { x = 33810, y = 32699, z = 8 } },
}

local TpTimira = MoveEvent()

function TpTimira.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	local newPos
	for _, info in pairs(positions) do
		if Position(info.tptimiraPos) == position then
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

TpTimira:type("stepin")

TpTimira:id(35500)

TpTimira:register()
