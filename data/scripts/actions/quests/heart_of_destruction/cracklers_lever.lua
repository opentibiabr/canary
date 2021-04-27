local function doCheckArea()
	local upConer = {x = 32192, y = 31311, z = 14}       -- upLeftCorner
	local downConer = {x = 32225, y = 31343, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k = upConer.z, downConer.z do
		        local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end

local function clearArea()
	local upConer = {x = 32192, y = 31311, z = 14}       -- upLeftCorner
	local downConer = {x = 32225, y = 31343, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k= upConer.z, downConer.z do
		        local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								c:teleportTo({x = 32078, y = 31320, z = 13})
							elseif isMonster(c) then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	stopEvent(areaCrackler1)
	stopEvent(areaCrackler2)
end

local function createVortex()
	local positions1 = {
		{x = 32197, y = 31322, z = 14},
		{x = 32202, y = 31328, z = 14},
		{x = 32208, y = 31324, z = 14},
		{x = 32210, y = 31334, z = 14},
	}

	local positions2 = {
		{x = 32202, y = 31325, z = 14},
		{x = 32201, y = 31334, z = 14},
		{x = 32215, y = 31332, z = 14},
		{x = 32208, y = 31320, z = 14},
	}

	local positions3 = {
		{x = 32199, y = 31329, z = 14},
		{x = 32207, y = 31335, z = 14},
		{x = 32208, y = 31327, z = 14},
		{x = 32213, y = 31322, z = 14},
	}

	local positions4 = {
		{x = 32203, y = 31319, z = 14},
		{x = 32205, y = 31325, z = 14},
		{x = 32212, y = 31330, z = 14},
		{x = 32219, y = 31328, z = 14},
	}
	local tempo = 10
	if vortexPositions == 0 then
		for i = 1, #positions1 do
			local items = Tile(Position(positions1[i])):getGround()
			items:transform(26127)
			addEvent(function()
			items:transform(25707)
			end, tempo*1000)
		end
		vortexPositions = 1
	elseif vortexPositions == 1 then
		for i = 1, #positions2 do
			local items = Tile(Position(positions2[i])):getGround()
			items:transform(26127)
			addEvent(function()
			items:transform(25707)
			end, tempo*1000)
		end
		vortexPositions = 2
	elseif vortexPositions == 2 then
		for i = 1, #positions3 do
			local items = Tile(Position(positions3[i])):getGround()
			items:transform(26127)
			addEvent(function()
			items:transform(25707)
			end, tempo*1000)
		end
		vortexPositions = 3
	elseif vortexPositions == 3 then
		for i = 1, #positions4 do
			local items = Tile(Position(positions4[i])):getGround()
			items:transform(26127)
			addEvent(function()
			items:transform(25707)
			end, tempo*1000)
		end
		vortexPositions = 0
	end

	cracklerTransform = false
	areaCrackler2 = addEvent(createVortex, tempo*1000)
end
-- FUNCTIONS END

local heartDestructionCracklers = Action()
function heartDestructionCracklers.onUse(player, item, fromPosition, itemEx, toPosition)

	local config = {
		playerPositions = {
			Position(32079, 31313, 13),
			Position(32079, 31314, 13),
			Position(32079, 31315, 13),
			Position(32079, 31316, 13),
			Position(32079, 31317, 13)
		},

		newPos = {x = 32219, y = 31325, z = 14},
	}

	local pushPos = {x = 32079, y = 31313, z = 13}

	if item.actionid == 14326 then
		if item.itemid == 9825 then
			if player:getPosition().x == pushPos.x and player:getPosition().y == pushPos.y and player:getPosition().z == pushPos.z then

				local storePlayers, playerTile = {}
				for i = 1, #config.playerPositions do
					playerTile = Tile(config.playerPositions[i]):getTopCreature()
					if isPlayer(playerTile) then
						storePlayers[#storePlayers + 1] = playerTile
					end
				end

				if #storePlayers < 4 then
					player:sendTextMessage(19, "You need at least 4 players to this mission.")
					return true
				end

				if doCheckArea() == false then
					clearArea()

					local players

					for i = 1, #storePlayers do
						players = storePlayers[i]
						config.playerPositions[i]:sendMagicEffect(CONST_ME_POFF)
						players:teleportTo(config.newPos)
					end
					Position(config.newPos):sendMagicEffect(11)

					areaCrackler1 = addEvent(clearArea, 15 * 60000)

					Game.createMonster("Crackler", {x = 32200, y = 31322, z = 14}, false, true)
					Game.createMonster("Crackler", {x = 32202, y = 31327, z = 14}, false, true)
					Game.createMonster("Crackler", {x = 32199, y = 31330, z = 14}, false, true)
					Game.createMonster("Crackler", {x = 32201, y = 31334, z = 14}, false, true)
					Game.createMonster("Crackler", {x = 32207, y = 31335, z = 14}, false, true)
					Game.createMonster("Crackler", {x = 32211, y = 31334, z = 14}, false, true)
					Game.createMonster("Crackler", {x = 32215, y = 31332, z = 14}, false, true)
					Game.createMonster("Crackler", {x = 32208, y = 31327, z = 14}, false, true)
					Game.createMonster("Crackler", {x = 32207, y = 31323, z = 14}, false, true)
					Game.createMonster("Crackler", {x = 32213, y = 31323, z = 14}, false, true)

					Game.setStorageValue(14323, 0) -- Depolarized Cracklers Count
					vortexPositions = 0
					createVortex()
				else
					player:sendTextMessage(19, "Someone is in the area.")
				end
			else
				return true
			end
		end
		item:transform(item.itemid == 9825 and 9826 or 9825)
	end

	return true
end

heartDestructionCracklers:aid(14326)
heartDestructionCracklers:register()