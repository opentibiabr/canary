local trees = {
	Position(32857, 32231, 11),
	Position(32857, 32232, 11),
	Position(32857, 32233, 11)
}

local deathRingTeleport = MoveEvent()

function deathRingTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(Position(32819, 32347, 9))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	for i = 1, #trees do
		if not Tile(trees[i]):getItemById(2722) then
			Game.createItem(2722, 1, trees[i])
			trees[i]:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
	end
	return true
end

deathRingTeleport:type("stepin")
deathRingTeleport:uid(9234)
deathRingTeleport:register()
