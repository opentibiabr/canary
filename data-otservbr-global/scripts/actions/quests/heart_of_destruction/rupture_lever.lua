-- FUNCTIONS
local function doCheckArea()
	local upConer = { x = 32324, y = 31239, z = 14 } -- upLeftCorner
	local downConer = { x = 32347, y = 31263, z = 14 } -- downRightCorner

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
	local upConer = { x = 32324, y = 31239, z = 14 } -- upLeftCorner
	local downConer = { x = 32347, y = 31263, z = 14 } -- downRightCorner

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
									creature:teleportTo({ x = 32088, y = 31321, z = 13 })
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

local heartDestructionRupture = Action()
function heartDestructionRupture.onUse(player, item, fromPosition, itemEx, toPosition)
	local config = {
		playerPositions = {
			Position(32309, 31248, 14),
			Position(32309, 31249, 14),
			Position(32309, 31250, 14),
			Position(32309, 31251, 14),
			Position(32309, 31252, 14),
		},

		newPos = { x = 32335, y = 31257, z = 14 },
	}

	local pushPos = { x = 32309, y = 31248, z = 14 }

	if item.actionid == 14327 then
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
						players:setBossCooldown("Rupture", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
					end
					Position(config.newPos):sendMagicEffect(11)

					areaRupture1 = addEvent(clearArea, 15 * 60000)

					ruptureResonanceStage = 0
					resonanceActive = false

					Game.createMonster("Spark of Destruction", { x = 32331, y = 31254, z = 14 }, false, true)
					Game.createMonster("Spark of Destruction", { x = 32338, y = 31254, z = 14 }, false, true)
					Game.createMonster("Spark of Destruction", { x = 32330, y = 31250, z = 14 }, false, true)
					Game.createMonster("Spark of Destruction", { x = 32338, y = 31250, z = 14 }, false, true)
					Game.createMonster("Rupture", { x = 32332, y = 31250, z = 14 }, false, true)

					local vortex = Tile({ x = 32326, y = 31250, z = 14 }):getItemById(23482)
					if vortex then
						vortex:transform(23483)
						vortex:setActionId(14343)
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

heartDestructionRupture:aid(14327)
heartDestructionRupture:register()
