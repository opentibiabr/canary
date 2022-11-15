local setting = {
	swimmingPosition = Position(32968, 32626, 5),
	caveEntrancePosition = Position(32968, 32631, 8),
	caveExitPosition = Position(32971, 32620, 8)
}

local waterfall = MoveEvent()

function waterfall.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	-- Jumping off the mountain edge into the water / onto water edge
	if position.x == 32966 and position.y == 32626 and position.z == 5 then
		player:teleportTo(setting.swimmingPosition)
		setting.swimmingPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
	-- Splash effect when jumping down the waterfall
	elseif position.x == 32968 and position.y == 32630 and position.z == 7 then
		position:sendMagicEffect(CONST_ME_WATERSPLASH)
	-- Teleport when entering the waterfall / cave
	elseif position.x == 32968 and position.y == 32629 and position.z == 7 then
		player:teleportTo(setting.caveEntrancePosition)
		player:setDirection(DIRECTION_SOUTH)
	-- Leaving the cave through teleport
	elseif position.x == 32967 and position.y == 32630 and position.z == 8 then
		player:teleportTo(setting.caveExitPosition)
		player:setDirection(DIRECTION_EAST)
	end
	return true
end

waterfall:type("stepin")
waterfall:aid(50022)
waterfall:register()
