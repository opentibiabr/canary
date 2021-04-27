local function shuffleTable(t, count, ri, rj)
	ri = ri or 1
	rj = rj or #t
	for x = 1, count or 1 do
		for i = rj, ri + 1, -1 do
			local j = math.random(ri, rj)
			t[i], t[j] = t[j], t[i]
		end
	end
end

local function doCheckArea()
	local upConer = {x = 32126, y = 31296, z = 14}       -- upLeftCorner
	local downConer = {x = 32162, y = 31322, z = 14}     -- downRightCorner

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
	local upConer = {x = 32126, y = 31296, z = 14}       -- upLeftCorner
	local downConer = {x = 32162, y = 31322, z = 14}     -- downRightCorner

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
								c:teleportTo({x = 32225, y = 31347, z = 11})
							elseif isMonster(c) then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	stopEvent(areaSparks1)
	stopEvent(areaSparks2)
	stopEvent(areaSparks3)
	stopEvent(areaSparks4)
end

function createSparks()

	local positions = {
		{x = 32132, y = 31306, z = 14},
		{x = 32133, y = 31309, z = 14},
		{x = 32132, y = 31312, z = 14},
		{x = 32136, y = 31302, z = 14},
		{x = 32136, y = 31307, z = 14},
		{x = 32137, y = 31311, z = 14},
		{x = 32138, y = 31314, z = 14},
		{x = 32139, y = 31304, z = 14},
		{x = 32141, y = 31307, z = 14},
		{x = 32141, y = 31310, z = 14},
		{x = 32141, y = 31315, z = 14},
		{x = 32145, y = 31317, z = 14},
		{x = 32144, y = 31313, z = 14},
		{x = 32145, y = 31309, z = 14},
		{x = 32145, y = 31302, z = 14},
		{x = 32149, y = 31304, z = 14},
		{x = 32152, y = 31302, z = 14},
		{x = 32154, y = 31305, z = 14},
		{x = 32148, y = 31315, z = 14},
		{x = 32150, y = 31312, z = 14},
		{x = 32153, y = 31315, z = 14},
		{x = 32157, y = 31313, z = 14},
		{x = 32154, y = 31310, z = 14},
		{x = 32157, y = 31308, z = 14},
		{x = 32157, y = 31302, z = 14},
	}

	if unstableSparksCount < 11 then
		shuffleTable(positions, 2, ri, rj)

		for i = 1, 15 do
			Game.createMonster("Unstable Spark", positions[i], false, true)
		end

		areaSparks3 = addEvent(renewSparks, 7000)
	end
end

function renewSparks()
	local upConer = {x = 32126, y = 31296, z = 14}       -- upLeftCorner
	local downConer = {x = 32162, y = 31322, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k= upConer.z, downConer.z do
		        local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							local cPos = c:getPosition()
							if isMonster(c) and c:getName() == "Unstable Spark" then
								cPos:sendMagicEffect(3)
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	areaSparks4 = addEvent(createSparks, 1000)
end

-- FUNCTIONS END
local heartDestructionSparks = Action()
function heartDestructionSparks.onUse(player, item, fromPosition, itemEx, toPosition)

	local config = {
		playerPositions = {
			Position(32227, 31343, 11),
			Position(32227, 31344, 11),
			Position(32227, 31345, 11),
			Position(32227, 31346, 11),
			Position(32227, 31347, 11)
		},

		newPos = {x = 32151, y = 31301, z = 14},
	}

	local pushPos = {x = 32227, y = 31343, z = 11}

	if item.actionid == 14328 then
		if item.itemid == 9825 then
			if player:getPosition().x == pushPos.x and player:getPosition().y == pushPos.y and player:getPosition().z == pushPos.z then

				local storePlayers, playerTile = {}
				for i = 1, #config.playerPositions do
					playerTile = Tile(config.playerPositions[i]):getTopCreature()
					if isPlayer(playerTile) then
						storePlayers[#storePlayers + 1] = playerTile
					end
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

					areaSparks1 = addEvent(clearArea, 15 * 60000)
					areaSparks2 = addEvent(createSparks, 10000)

					unstableSparksCount = 0
					--Game.createMonster("Crackler", {x = 32200, y = 31322, z = 14}, false, true)
					player:say("The room slowly beginns to crackle. An erruption seems imanent!", TALKTYPE_MONSTER_YELL, isInGhostMode, pid, {x = 32143, y = 31308, z = 14})
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

heartDestructionSparks:aid(14328)
heartDestructionSparks:register()