-- FUNCTIONS
local function doCheckArea()
	local upConer = { x = 32197, y = 31236, z = 14 } -- upLeftCorner
	local downConer = { x = 32220, y = 31260, z = 14 } -- downRightCorner

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
	local upConer = { x = 32197, y = 31236, z = 14 } -- upLeftCorner
	local downConer = { x = 32220, y = 31260, z = 14 } -- downRightCorner

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
									creature:teleportTo({ x = 32230, y = 31358, z = 11 })
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
			Position(32182, 31248, 14),
		},

		newPos = { x = 32208, y = 31256, z = 14 },
	}

	local pushPos = { x = 32182, y = 31244, z = 14 }

	if item.actionid == 14329 then
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
						players:setBossCooldown("Realityquake", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
					end
					Position(config.newPos):sendMagicEffect(11)

					areaQuake1 = addEvent(clearArea, 15 * 60000)

					Game.createMonster("Spark of Destruction", { x = 32203, y = 31246, z = 14 }, false, true)
					Game.createMonster("Spark of Destruction", { x = 32205, y = 31251, z = 14 }, false, true)
					Game.createMonster("Spark of Destruction", { x = 32210, y = 31251, z = 14 }, false, true)
					Game.createMonster("Spark of Destruction", { x = 32212, y = 31246, z = 14 }, false, true)
					Game.createMonster("Foreshock", { x = 32208, y = 31248, z = 14 }, false, true)

					foreshockHealth = 105000
					aftershockHealth = 105000
					foreshockStage = 0
					aftershockStage = 0

					local vortex = Tile({ x = 32199, y = 31248, z = 14 }):getItemById(23482)
					if vortex then
						vortex:transform(23483)
						vortex:setActionId(14345)
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

heartDestructionQuake:aid(14329)
heartDestructionQuake:register()
