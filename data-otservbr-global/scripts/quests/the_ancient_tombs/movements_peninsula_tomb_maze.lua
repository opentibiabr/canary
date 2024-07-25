local peninsulaTombMaze = MoveEvent()

function peninsulaTombMaze.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(fromPosition, true)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

peninsulaTombMaze:type("stepin")
peninsulaTombMaze:aid(12101)
peninsulaTombMaze:register()
