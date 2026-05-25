local manInTheCave = MoveEvent()

function manInTheCave.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local config = {
		stepPos = { x = 32131, y = 31147, z = 3 },
		fromPos = { x = 32124, y = 31141, z = 2 },
		toPos = { x = 32142, y = 31153, z = 2 },
		teleportPos = { x = 32131, y = 31146, z = 2 },
		monsterName = "Man In The Cave",
	}

	if position.x ~= config.stepPos.x or position.y ~= config.stepPos.y or position.z ~= config.stepPos.z then
		return true
	end

	local monsterFound = false
	local monsterTarget = nil

	for x = config.fromPos.x, config.toPos.x do
		for y = config.fromPos.y, config.toPos.y do
			local tile = Tile(Position(x, y, config.fromPos.z))
			if tile then
				local creatures = tile:getCreatures()
				for _, creature in ipairs(creatures) do
					if creature:isMonster() and creature:getName():lower() == config.monsterName:lower() then
						monsterFound = true
						monsterTarget = creature
						break
					end
				end
			end
			if monsterFound then
				break
			end
		end
		if monsterFound then
			break
		end
	end

	if monsterFound and monsterTarget then
		player:teleportTo(config.teleportPos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You have been roped up!", TALKTYPE_MONSTER_SAY)
	end

	return true
end

manInTheCave:type("stepin")
manInTheCave:id(799, 6594)
manInTheCave:register()
