-- FUNCTIONS
local function doCheckArea()
	local upConer = {x = 32197, y = 31236, z = 14}       -- upLeftCorner
	local downConer = {x = 32220, y = 31260, z = 14}     -- downRightCorner

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
	local upConer = {x = 32197, y = 31236, z = 14}       -- upLeftCorner
	local downConer = {x = 32220, y = 31260, z = 14}     -- downRightCorner

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
								c:teleportTo({x = 32230, y = 31358, z = 11})
							elseif isMonster(c) then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	stopEvent(areaQuake1)
end
-- FUNCTIONS END

local heartDestructionQuake = Action()
function heartDestructionQuake.onUse(player, item, fromPosition, itemEx, toPosition)

	local config = {
		playerPositions = {
			Position(32182, 31244, 14),
			Position(32182, 31245, 14),
			Position(32182, 31246, 14),
			Position(32182, 31247, 14),
			Position(32182, 31248, 14)
		},

		newPos = {x = 32208, y = 31256, z = 14},
	}

	local pushPos = {x = 32182, y = 31244, z = 14}

	if item.actionid == 14329 then
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
						players:setStorageValue(14325, os.time() + 20*60*60)
					end
					Position(config.newPos):sendMagicEffect(11)

					areaQuake1 = addEvent(clearArea, 15 * 60000)

					Game.createMonster("Spark of Destruction", {x = 32203, y = 31246, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32205, y = 31251, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32210, y = 31251, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32212, y = 31246, z = 14}, false, true)
					Game.createMonster("Foreshock", {x = 32208, y = 31248, z = 14}, false, true)

					foreshockHealth = 105000
					aftershockHealth = 105000
					realityQuakeStage = 0
					foreshockStage = 0
					aftershockStage = 0

					local vortex = Tile({x = 32199, y = 31248, z = 14}):getItemById(26138)
					if vortex then
						vortex:transform(26139)
						vortex:setActionId(14345)
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

heartDestructionQuake:aid(14329)
heartDestructionQuake:register()