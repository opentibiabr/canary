-- FUNCTIONS
local function doCheckArea()
	local upConer = {x = 32297, y = 31272, z = 14}       -- upLeftCorner
	local downConer = {x = 32321, y = 31296, z = 14}     -- downRightCorner

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
	local upConer = {x = 32297, y = 31272, z = 14}       -- upLeftCorner
	local downConer = {x = 32321, y = 31296, z = 14}     -- downRightCorner

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
								c:teleportTo({x = 32218, y = 31375, z = 11})
							elseif isMonster(c) then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	stopEvent(areaEradicator1)
	stopEvent(areaEradicator2)
end
-- FUNCTIONS END

local heartDestructionEradicator = Action()
function heartDestructionEradicator.onUse(player, item, fromPosition, itemEx, toPosition)

	local config = {
		playerPositions = {
			Position(32334, 31284, 14),
			Position(32334, 31285, 14),
			Position(32334, 31286, 14),
			Position(32334, 31287, 14),
			Position(32334, 31288, 14)
		},

		newPos = {x = 32309, y = 31290, z = 14},
	}

	local pushPos = {x = 32334, y = 31284, z = 14}

	if item.actionid == 14330 then
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
						players:setStorageValue(14329, os.time() + 20*60*60)
					end
					Position(config.newPos):sendMagicEffect(11)

					eradicatorReleaseT = false -- Liberar Spell
					eradicatorWeak = 0 -- Eradicator Form
					areaEradicator1 = addEvent(clearArea, 15 * 60000)
					areaEradicator2 = addEvent(function() eradicatorReleaseT = true end, 74000)

					Game.createMonster("Spark of Destruction", {x = 32304, y = 31282, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32305, y = 31287, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32312, y = 31287, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32314, y = 31282, z = 14}, false, true)
					Game.createMonster("Eradicator", {x = 32309, y = 31283, z = 14}, false, true)

					local vortex = Tile({x = 32318, y = 31284, z = 14}):getItemById(26138)
					if vortex then
						vortex:transform(26139)
						vortex:setActionId(14348)
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

heartDestructionEradicator:aid(14330)
heartDestructionEradicator:register()