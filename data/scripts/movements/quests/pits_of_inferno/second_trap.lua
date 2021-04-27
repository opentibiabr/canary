local stonePosition = Position(32826, 32274, 11)

function removeStone()
	local stoneItem = Tile(stonePosition):getItemById(1285)
	if stoneItem then
		stoneItem:remove()
		stonePosition:sendMagicEffect(CONST_ME_POFF)
	end
end

local secondTrap = MoveEvent()

function secondTrap.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(Position(32826, 32273, 12))
	player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
	Game.createItem(1285, 1, stonePosition)
	addEvent(removeStone, 10 * 1000)
	return true
end

secondTrap:type("stepin")
secondTrap:uid(3303)
secondTrap:register()
