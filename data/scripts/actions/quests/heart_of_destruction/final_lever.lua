--[[
Storages:
The Hunger = 14334
The Destruction = 14335
The Rage = 14336
]]--
-- FUNCTIONS
function sparkDevourerSpawn()
	local positions = {
		{x = 32268, y = 31341, z = 14},
		{x = 32275, y = 31342, z = 14},
		{x = 32269, y = 31352, z = 14},
		{x = 32277, y = 31351, z = 14}
	}

	if sparkSpawnCount > 0 then
		for i = 1, sparkSpawnCount do
			Game.createMonster("Spark of Destruction2", positions[i], false, true)
		end
		sparkSpawnCount = 0
	end
	areaDevourer6 = addEvent(sparkDevourerSpawn, 10000)
end

local function doCheckArea()
	local upConer = {x = 32260, y = 31336, z = 14}       -- upLeftCorner
	local downConer = {x = 32283, y = 31360, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k = upConer.z, downConer.z do
				local tile = Tile(i, j, k)
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

	for _, online in ipairs(Game.getPlayers()) do
		if online:isPlayer() then
			if online:getStorageValue(14334) >= 1 or online:getStorageValue(14335) >= 1 or online:getStorageValue(14336) >= 1 then
				return true
			end
		end
	end

	return false
end

local function changeArea()
	local function organizeHunger()
		local upConer = {x = 32233, y = 31360, z = 14}       -- upLeftCorner
		local downConer = {x = 32256, y = 31384, z = 14}     -- downRightCorner
		for i=upConer.x, downConer.x do
			for j=upConer.y, downConer.y do
		    	for k = upConer.z, downConer.z do
					local tile = Tile(i, j, k)
					if tile then
						local creatures = tile:getCreatures()
						if creatures and #creatures > 0 then
							if theHungerKilled == false then
								for _, c in pairs(creatures) do
									if isMonster(c) then
										c:teleportTo({x = 32244, y = 31369, z = 14})
									end
								end
							else
								devourerBossesKilled = devourerBossesKilled - 1
								Game.createMonster("The Hunger", {x = 32244, y = 31372, z = 14}, false, true)
								theHungerKilled = false
							end
						end
					end
				end
			end
		end
	end

	local function organizeDestruction()
		local upConer = {x = 32260, y = 31304, z = 14}       -- upLeftCorner
		local downConer = {x = 32283, y = 31328, z = 14}     -- downRightCorner
		for i=upConer.x, downConer.x do
			for j=upConer.y, downConer.y do
		    	for k = upConer.z, downConer.z do
					local tile = Tile(i, j, k)
					if tile then
						local creatures = tile:getCreatures()
						if creatures and #creatures > 0 then
							if theDestructionKilled == false then
								for _, c in pairs(creatures) do
									if isMonster(c) then
										c:teleportTo({x = 32271, y = 31313, z = 14})
									end
								end
							else
								devourerBossesKilled = devourerBossesKilled - 1
								Game.createMonster("The Destruction", {x = 32271, y = 31316, z = 14}, false, true)
								theDestructionKilled = false
							end
						end
					end
				end
			end
		end
	end

	local function organizeRage()
		local upConer = {x = 32288, y = 31360, z = 14}       -- upLeftCorner
		local downConer = {x = 32311, y = 31384, z = 14}     -- downRightCorner
		for i=upConer.x, downConer.x do
			for j=upConer.y, downConer.y do
				for k = upConer.z, downConer.z do
					local tile = Tile(i, j, k)
					if tile then
						local creatures = tile:getCreatures()
						if creatures and #creatures > 0 then
							if theRageKilled == false then
								for _, c in pairs(creatures) do
									if isMonster(c) then
										c:teleportTo({x = 32299, y = 31369, z = 14})
									end
								end
							else
								devourerBossesKilled = devourerBossesKilled - 1
								Game.createMonster("The Rage", {x = 32299, y = 31372, z = 14}, false, true)
								theRageKilled = false
							end
						end
					end
				end
			end
		end
	end

	if devourerBossesKilled < 3 then
		for _, online in ipairs(Game.getPlayers()) do
			if online:isPlayer() then
				-- Teleport players from The Hunger to The Rage
				if online:getStorageValue(14334) >= 1 then
					online:setStorageValue(14334, -1)
					online:setStorageValue(14336, 1)
					online:teleportTo({x = 32299, y = 31372, z = 14})
					online:say("A polarity shift moves you into another part of the heart of destruction.", TALKTYPE_MONSTER_SAY)
					Position({x = 32299, y = 31372, z = 14}):sendMagicEffect(11)
				-- Teleport players from The Destruction to The Hunger
				elseif online:getStorageValue(14335) >= 1 then
					online:setStorageValue(14335, -1)
					online:setStorageValue(14334, 1)
					online:teleportTo({x = 32244, y = 31372, z = 14})
					online:say("A polarity shift moves you into another part of the heart of destruction.", TALKTYPE_MONSTER_SAY)
					Position({x = 32244, y = 31372, z = 14}):sendMagicEffect(11)
				-- Teleport players from The Rage to The Destruction
				elseif online:getStorageValue(14336) >= 1 then
					online:setStorageValue(14336, -1)
					online:setStorageValue(14335, 1)
					online:teleportTo({x = 32271, y = 31316, z = 14})
					online:say("A polarity shift moves you into another part of the heart of destruction.", TALKTYPE_MONSTER_SAY)
					Position({x = 32271, y = 31316, z = 14}):sendMagicEffect(11)
				end
			end
		end
		organizeHunger()
		organizeDestruction()
		organizeRage()
		areaDevourer4 = addEvent(changeArea, 30000)
	else
		stopEvent(areaDevourer1)
		stopEvent(areaDevourer2)
		stopEvent(areaDevourer3)
		stopEvent(areaDevourer4)
		for _, online in ipairs(Game.getPlayers()) do
			if online:isPlayer() then
				if online:getStorageValue(14334) >= 1 then
					online:setStorageValue(14334, -1)
					online:unregisterEvent("DevourerStorage")
					online:teleportTo({x = 32271, y = 31357, z = 14})
					Position({x = 32271, y = 31357, z = 14}):sendMagicEffect(11)
				elseif online:getStorageValue(14335) >= 1 then
					online:setStorageValue(14335, -1)
					online:unregisterEvent("DevourerStorage")
					online:teleportTo({x = 32272, y = 31357, z = 14})
					Position({x = 32272, y = 31357, z = 14}):sendMagicEffect(11)
				elseif online:getStorageValue(14336) >= 1 then
					online:setStorageValue(14336, -1)
					online:unregisterEvent("DevourerStorage")
					online:teleportTo({x = 32273, y = 31357, z = 14})
					Position({x = 32273, y = 31357, z = 14}):sendMagicEffect(11)
				end
			end
		end
		local spectators = Game.getSpectators(Position(32271, 31348, 14), false, true, 10, 10, 10, 10)
		if #spectators > 0 then
			for i = 1, #spectators do
				spectators[i]:say("With the Rage, Hunger and Destruction gone, you're sucked into the heart of destruction!! THE WORLD DEVOURER AWAITS YOU!", TALKTYPE_MONSTER_YELL, false, spectators[i], Position(32271, 31348, 14))
			end
		end

		Game.createMonster("World Devourer", {x = 32271, y = 31347, z = 14}, false, true)
		Game.createMonster("Spark of Destruction2", {x = 32268, y = 31341, z = 14}, false, true)
		Game.createMonster("Spark of Destruction2", {x = 32275, y = 31342, z = 14}, false, true)
		Game.createMonster("Spark of Destruction2", {x = 32269, y = 31352, z = 14}, false, true)
		Game.createMonster("Spark of Destruction2", {x = 32277, y = 31351, z = 14}, false, true)
		sparkSpawnCount = 0
		devourerSummon = 0
		areaDevourer5 = addEvent(clearDevourer, 30 * 60000)
		areaDevourer6 = addEvent(sparkDevourerSpawn, 10000)
	end
end

local function clearHunger()
	local upConer = {x = 32233, y = 31360, z = 14}       -- upLeftCorner
	local downConer = {x = 32256, y = 31384, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k = upConer.z, downConer.z do
				local tile = Tile(i, j, k)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								c:teleportTo({x = 32208, y = 31372, z = 14})
							elseif isMonster(c) and c:getName() ~= "Spark of Destruction" then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	stopEvent(areaDevourer1)
end

local function clearDestruction()
	local upConer = {x = 32260, y = 31304, z = 14}       -- upLeftCorner
	local downConer = {x = 32283, y = 31328, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k = upConer.z, downConer.z do
				local tile = Tile(i, j, k)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								c:teleportTo({x = 32208, y = 31372, z = 14})
							elseif isMonster(c) and c:getName() ~= "Spark of Destruction" then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	stopEvent(areaDevourer2)
end

local function clearRage()
	local upConer = {x = 32288, y = 31360, z = 14}       -- upLeftCorner
	local downConer = {x = 32311, y = 31384, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k = upConer.z, downConer.z do
				local tile = Tile(i, j, k)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								c:teleportTo({x = 32208, y = 31372, z = 14})
							elseif isMonster(c) and c:getName() ~= "Spark of Destruction" then
								c:remove()
							end
						end
					end
				end
			end
		end
	end
	stopEvent(areaDevourer3)
end

function clearDevourer()
	local upConer = {x = 32260, y = 31336, z = 14}       -- upLeftCorner
	local downConer = {x = 32283, y = 31360, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k = upConer.z, downConer.z do
				local tile = Tile(i, j, k)
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
	stopEvent(areaDevourer4)
	stopEvent(areaDevourer5)
	stopEvent(areaDevourer6)
end
-- FUNCTIONS END

local heartDestructionFinal = Action()
function heartDestructionFinal.onUse(player, item, fromPosition, itemEx, toPosition)

	local config = {
		hungerPositions = {
			Position(32271, 31374, 14),
			Position(32271, 31375, 14),
			Position(32271, 31376, 14),
			Position(32271, 31377, 14),
			Position(32271, 31378, 14)
		},

		destructionPositions = {
			Position(32272, 31374, 14),
			Position(32272, 31375, 14),
			Position(32272, 31376, 14),
			Position(32272, 31377, 14),
			Position(32272, 31378, 14)
		},

		ragePositions = {
			Position(32273, 31374, 14),
			Position(32273, 31375, 14),
			Position(32273, 31376, 14),
			Position(32273, 31377, 14),
			Position(32273, 31378, 14)
		},

		hungerNewPos = {x = 32244, y = 31381, z = 14},
		destructionNewPos = {x = 32271, y = 31325, z = 14},
		rageNewPos = {x = 32299, y = 31381, z = 14},
	}

	local pushPos = {x = 32272, y = 31374, z = 14}

	if item.actionid == 14332 then
		if item.itemid == 9825 then
			if player:getPosition().x == pushPos.x and player:getPosition().y == pushPos.y and player:getPosition().z == pushPos.z then

				local storeHunger, hungerTile = {}
				local storeDestruction, destructionTile = {}
				local storeRage, rageTile = {}

				for i = 1, #config.hungerPositions do
					hungerTile = Tile(config.hungerPositions[i]):getTopCreature()
					if isPlayer(hungerTile) then
						storeHunger[#storeHunger + 1] = hungerTile
					end
				end

				for i = 1, #config.destructionPositions do
					destructionTile = Tile(config.destructionPositions[i]):getTopCreature()
					if isPlayer(destructionTile) then
						storeDestruction[#storeDestruction + 1] = destructionTile
					end
				end

				for i = 1, #config.ragePositions do
					rageTile = Tile(config.ragePositions[i]):getTopCreature()
					if isPlayer(rageTile) then
						storeRage[#storeRage + 1] = rageTile
					end
				end

				if #storeHunger < 1 or #storeDestruction < 1 or #storeRage < 1 then
					player:sendTextMessage(19, "You need at least 3 players, each in a column.")
					return true
				end

				if doCheckArea() == false then
					clearHunger()
					clearDestruction()
					clearRage()
					clearDevourer()

					local teamHunger
					local teamDestruction
					local teamRage

					for i = 1, #storeHunger do
						teamHunger = storeHunger[i]
						config.hungerPositions[i]:sendMagicEffect(CONST_ME_POFF)
						teamHunger:teleportTo(config.hungerNewPos)
						teamHunger:setStorageValue(14333, os.time() + 7*24*60*60)
						teamHunger:setStorageValue(14334, 1) --storage Hunger
						teamHunger:registerEvent("DevourerStorage")
					end

					for i = 1, #storeDestruction do
						teamDestruction = storeDestruction[i]
						config.destructionPositions[i]:sendMagicEffect(CONST_ME_POFF)
						teamDestruction:teleportTo(config.destructionNewPos)
						teamDestruction:setStorageValue(14333, os.time() + 7*24*60*60)
						teamDestruction:setStorageValue(14335, 1) --storage Destruction
						teamDestruction:registerEvent("DevourerStorage")
					end

					for i = 1, #storeRage do
						teamRage = storeRage[i]
						config.ragePositions[i]:sendMagicEffect(CONST_ME_POFF)
						teamRage:teleportTo(config.rageNewPos)
						teamRage:setStorageValue(14333, os.time() + 7*24*60*60)
						teamRage:setStorageValue(14336, 1) --storage Rage
						teamRage:registerEvent("DevourerStorage")
					end

					Position(config.hungerNewPos):sendMagicEffect(11)
					Position(config.destructionNewPos):sendMagicEffect(11)
					Position(config.rageNewPos):sendMagicEffect(11)

					areaDevourer1 = addEvent(clearHunger, 30 * 60000)
					areaDevourer2 = addEvent(clearDestruction, 30 * 60000)
					areaDevourer3 = addEvent(clearRage, 30 * 60000)
					areaDevourer4 = addEvent(changeArea, 30000) --mudar

					--Variables
					devourerBossesKilled = 0
					theHungerKilled = false
					theDestructionKilled = false
					theRageKilled = false

					hungerSummon = 0
					rageSummon = 0
					destructionSummon = 0
					devourerSummon = 0

					Game.createMonster("The Hunger", {x = 32244, y = 31372, z = 14}, false, true)
					Game.createMonster("The Destruction", {x = 32271, y = 31316, z = 14}, false, true)
					Game.createMonster("The Rage", {x = 32299, y = 31372, z = 14}, false, true)

					local vortex = Tile({x = 32281, y = 31348, z = 14}):getItemById(26138)
					if vortex then
						vortex:transform(26139)
						vortex:setActionId(14352)
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

heartDestructionFinal:aid(14332)
heartDestructionFinal:register()