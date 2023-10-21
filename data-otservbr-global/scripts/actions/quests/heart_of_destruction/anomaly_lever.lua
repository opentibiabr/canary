-- FUNCTIONS
local function doCheckArea()
	local upConer = { x = 32258, y = 31237, z = 14 } -- upLeftCorner
	local downConer = { x = 32284, y = 31262, z = 14 } -- downRightCorner

	for i = upConer.x, downConer.x do
		for j = upConer.y, downConer.y do
			for k = upConer.z, downConer.z do
				local room = { x = i, y = j, z = k }
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, creature in pairs(creatures) do
							local player = Player(creature)
							if player then
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
	local upConer = { x = 32258, y = 31237, z = 14 } -- upLeftCorner
	local downConer = { x = 32284, y = 31262, z = 14 } -- downRightCorner

	for i = upConer.x, downConer.x do
		for j = upConer.y, downConer.y do
			for k = upConer.z, downConer.z do
				local room = { x = i, y = j, z = k }
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, creatureUid in pairs(creatures) do
							local creature = Creature(creatureUid)
							if creature then
								if creature:isPlayer() then
									creature:teleportTo({ x = 32104, y = 31329, z = 12 })
								elseif creature:isMonster() then
									creature:remove()
								end
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
			Position(32245, 31249, 14),
		},

		newPos = { x = 32271, y = 31257, z = 14 },
	}

	local pushPos = { x = 32245, y = 31245, z = 14 }

	if item.actionid == 14325 then
		if item.itemid == 8911 then
			if player:getPosition().x == pushPos.x and player:getPosition().y == pushPos.y and player:getPosition().z == pushPos.z then
				local storePlayers = {}
				for i = 1, #config.playerPositions do
					local tile = Tile(Position(config.playerPositions[i]))
					if tile then
						local playerTile = tile:getTopCreature()
						if playerTile and playerTile:isPlayer() then
							storePlayers[#storePlayers + 1] = playerTile
						end
					end
				end

				if doCheckArea() == false then
					clearArea()

					local players

					for i = 1, #storePlayers do
						players = storePlayers[i]
						config.playerPositions[i]:sendMagicEffect(CONST_ME_POFF)
						players:teleportTo(config.newPos)
						players:setBossCooldown("Anomaly", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
					end
					Position(config.newPos):sendMagicEffect(11)

					areaAnomaly1 = addEvent(clearArea, 15 * 60000)

					Game.setStorageValue(14322, 0) -- Anomaly Stages

					Game.createMonster("Spark of Destruction", { x = 32267, y = 31253, z = 14 }, false, true)
					Game.createMonster("Spark of Destruction", { x = 32274, y = 31255, z = 14 }, false, true)
					Game.createMonster("Spark of Destruction", { x = 32274, y = 31249, z = 14 }, false, true)
					Game.createMonster("Spark of Destruction", { x = 32267, y = 31249, z = 14 }, false, true)
					Game.createMonster("Anomaly", { x = 32271, y = 31249, z = 14 }, false, true)

					local vortex = Tile({ x = 32261, y = 31250, z = 14 }):getItemById(23482)
					if vortex then
						vortex:transform(23483)
						vortex:setActionId(14324)
					end
				else
					player:sendTextMessage(19, "Someone is in the area.")
				end
			else
				return true
			end
		end
		item:transform(item.itemid == 8911 and 8912 or 8911)
	end
	return true
end

heartDestructionAnomaly:aid(14325)
heartDestructionAnomaly:register()
