-- FUNCTIONS
local function doCheckArea()
	local upConer = {x = 32258, y = 31237, z = 14}       -- upLeftCorner
	local downConer = {x = 32284, y = 31262, z = 14}     -- downRightCorner

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
	local upConer = {x = 32258, y = 31237, z = 14}       -- upLeftCorner
	local downConer = {x = 32284, y = 31262, z = 14}     -- downRightCorner

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
								c:teleportTo({x = 32104, y = 31329, z = 12})
							elseif isMonster(c) then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
end
-- FUNCTIONS END

local heartDestructionAnomaly = Action()
function heartDestructionAnomaly.onUse(player, item, fromPosition, itemEx, toPosition)

	local config = {
		playerPositions = {
			Position(32245, 31245, 14),
			Position(32245, 31246, 14),
			Position(32245, 31247, 14),
			Position(32245, 31248, 14),
			Position(32245, 31249, 14)
		},

		newPos = {x = 32271, y = 31257, z = 14},
	}

	local pushPos = {x = 32245, y = 31245, z = 14}

	if item.actionid == 14325 then
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
						players:setStorageValue(14321, os.time() + 20*60*60)
					end
					Position(config.newPos):sendMagicEffect(11)

					areaAnomaly1 = addEvent(clearArea, 15 * 60000)

					Game.setStorageValue(14322, 0) -- Anomaly Stages

					Game.createMonster("Spark of Destruction", {x = 32267, y = 31253, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32274, y = 31255, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32274, y = 31249, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32267, y = 31249, z = 14}, false, true)
					Game.createMonster("Anomaly", {x = 32271, y = 31249, z = 14}, false, true)

					local vortex = Tile({x = 32261, y = 31250, z = 14}):getItemById(26138)
					if vortex then
						vortex:transform(26139)
						vortex:setActionId(14324)
					end
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

heartDestructionAnomaly:aid(14325)
heartDestructionAnomaly:register()