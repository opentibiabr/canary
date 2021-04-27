-- FUNCTIONS
local function doCheckArea()
	local upConer = {x = 32223, y = 31273, z = 14}       -- upLeftCorner
	local downConer = {x = 32246, y = 31297, z = 14}     -- downRightCorner

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
	local upConer = {x = 32223, y = 31273, z = 14}       -- upLeftCorner
	local downConer = {x = 32246, y = 31297, z = 14}     -- downRightCorner

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
								c:teleportTo({x = 32208, y = 31372, z = 14})
							elseif isMonster(c) then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	stopEvent(areaOutburst1)
end
-- FUNCTIONS END

local heartDestructionOutburst = Action()
function heartDestructionOutburst.onUse(player, item, fromPosition, itemEx, toPosition)

	local config = {
		playerPositions = {
			Position(32207, 31284, 14),
			Position(32207, 31285, 14),
			Position(32207, 31286, 14),
			Position(32207, 31287, 14),
			Position(32207, 31288, 14)
		},

		newPos = {x = 32234, y = 31292, z = 14},
	}

	local pushPos = {x = 32207, y = 31284, z = 14}

	if item.actionid == 14331 then
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
						players:setStorageValue(14331, os.time() + 20*60*60)
					end
					Position(config.newPos):sendMagicEffect(11)

					areaOutburst1 = addEvent(clearArea, 15 * 60000)

					Game.createMonster("Spark of Destruction", {x = 32229, y = 31282, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32230, y = 31287, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32237, y = 31287, z = 14}, false, true)
					Game.createMonster("Spark of Destruction", {x = 32238, y = 31282, z = 14}, false, true)
					Game.createMonster("Outburst", {x = 32234, y = 31284, z = 14}, false, true)

					outburstStage = 0
					outburstHealth = 290000

					local vortex = Tile({x = 32225, y = 31285, z = 14}):getItemById(26138)
					if vortex then
						vortex:transform(26139)
						vortex:setActionId(14350)
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

heartDestructionOutburst:aid(14331)
heartDestructionOutburst:register()