-- First magic wall (first lever)
local firstSealCloseMw = MoveEvent()

function firstSealCloseMw.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local magicWallPosition = {x = 32259, y = 31890, z = 10}
	if Position(magicWallPosition):createItem(1498) then
		stopEvent(Position.revertItem)
	end
	return true
end

firstSealCloseMw:position({x = 32257, y = 31887, z = 10})
firstSealCloseMw:register()

-- Second magic wall (second lever)
local firstSealCloseMw = MoveEvent()

function firstSealCloseMw.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local magicWallPosition = {x = 32259, y = 31891, z = 10}
	if Position(magicWallPosition):createItem(1498) then
		stopEvent(Position.revertItem)
	end
	return true
end

firstSealCloseMw:position({x = 32258, y = 31887, z = 10})
firstSealCloseMw:register()

-- Third magic wall (third lever)
local firstSealCloseMw = MoveEvent()

function firstSealCloseMw.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local magicWallPosition = {x = 32266, y = 31860, z = 11}
	Position(magicWallPosition):removeItem(369)

	local leverPosition = {x = 32266, y = 31861, z = 11}
	Position.revertItem(magicWallPosition, 1498, leverPosition, 1946, 32400)
	return true
end

firstSealCloseMw:position({x = 32266, y = 31860, z = 12})
firstSealCloseMw:register()
