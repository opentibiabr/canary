local transformid = {
	[8911] = 8912,
	[8912] = 8911,
}

local geyser = {
	[1] = Position(33132, 31917, 15),
	[2] = Position(33135, 31919, 15),
	[3] = Position(33135, 31923, 15),
	[4] = Position(33128, 31922, 15),
	[5] = Position(33128, 31918, 15),
	[6] = Position(33124, 31920, 15),
	[7] = Position(33124, 31925, 15),
	[8] = Position(33131, 31927, 15),
	[9] = Position(33135, 31926, 15),
	[10] = Position(33128, 31929, 15),
	[11] = Position(33133, 31930, 15),
	[12] = Position(33127, 31933, 15),
}

local function spawnStolenSoul(t_time)
	if t_time == 0 then
		local a1 = Position(33034, 31916, 15)
		local a2 = Position(33048, 31927, 15)
		if not isPlayerInArea(a1, a2) then
			return true
		end
		local newArea = Position(math.random(a1.x, a2.x), math.random(a1.y, a2.y), math.random(a1.z, a2.z))
		Game.createMonster(math.random(1, 2) == 1 and "Stolen Soul" or "Soul Reaper", newArea)
		t_time = 31
	end
	addEvent(spawnStolenSoul, 1000, t_time - 1)
end

local function spawnDarkSoul(area, t_time)
	if t_time == 0 then
		local waitingForPlayer = false
		local p1 = Position(33023, 31904, 14)
		local p2 = Position(33037, 31915, 14)
		local sA1 = Position(33028, 31908, 14)
		local sA2 = Position(33036, 31914, 14)
		if area == 2 then
			p1 = Position(33039, 31902, 14)
			p2 = Position(33052, 31916, 14)
			sA1 = Position(33042, 31908, 14)
			sA2 = Position(33051, 31914, 14)
		end
		if not isPlayerInArea(p1, p2) then
			local a1 = Position(33034, 31916, 15)
			local a2 = Position(33048, 31927, 15)
			if not isPlayerInArea(a1, a2) then
				return true
			end
			waitingForPlayer = true
		else
			local monsters = {}
			for _x = sA1.x, sA2.x, 1 do
				for _y = sA1.y, sA2.y, 1 do
					local tileMonster = Tile(Position(_x, _y, sA1.z)):getTopCreature()
					if tileMonster and tileMonster:isMonster() and tileMonster:getName() == "Dark Soul" then
						monsters[#monsters + 1] = tileMonster
					end
				end
			end
			if #monsters >= 4 then
				for _, pid in pairs(monsters) do
					pid:remove()
				end
			end
			local newPos = Position(math.random(sA1.x, sA2.x), math.random(sA1.y, sA2.y), math.random(sA1.z, sA2.z))
			Game.createMonster("Dark Soul", newPos)
		end
		addEvent(spawnDarkSoul, 1000, area, (waitingForPlayer and 1 or 30))
	else
		addEvent(spawnDarkSoul, 1000, area, t_time - 1)
	end
end

local function transformMonster(itid, action, monster, frompos, topos, _temp)
	if action == 1 then
		local delay = _temp
		for _x = frompos.x, topos.x, 1 do
			local tile = Tile(Position(_x, frompos.y, frompos.z))
			if _x % 2 == 0 then
				delay = delay + 1
				if tile then
					if tile:getItemCountById(itid) < 1 then
						Game.createItem(itid, 1, Position(_x, frompos.y, frompos.z))
					end
					addEvent(transformMonster, delay * 15000, itid, 2, monster, Position(_x, frompos.y, frompos.z), {}, _temp + 1)
				end
			end
		end
	elseif action == 2 then
		local tile = Tile(frompos)
		if tile:getItemCountById(itid) > 0 then
			tile:getItemById(itid):remove()
		end
		Game.createMonster(monster, frompos)
	elseif action == 3 then
		local pos = Position(33158, 31912, 15)
		local pos2 = Position(33169, 31919, 15)
		Game.createMonster(monster, { x = math.random(pos.x, pos2.x), y = math.random(pos.y, pos2.y), z = pos2.z })
		if _temp < itid then
			_temp = _temp + 1
			addEvent(transformMonster, 15000, itid, 3, "Sphere Of Wrath", {}, {}, _temp)
		end
	end
end

local function activateGeyser(player)
	local frompos = Position(33119, 31913, 15)
	local topos = Position(33142, 31936, 15)
	if isPlayerInArea(frompos, topos) then
		addEvent(function()
			local rand = math.random(1, 12)
			local geyserPos = Position(geyser[rand])
			local check1 = Tile(Position(geyserPos)):getItemById(25509)
			if check1 then
				addEvent(function()
					local player1 = Game.getPlayers()[1]
					Game.createItem(25510, 1, geyserPos)
					player1:say("SPLASH!", TALKTYPE_MONSTER_SAY, false, false, geyserPos)
					addEvent(function()
						local check2 = Tile(Position(geyserPos)):getItemById(25510)
						if check2 then
							check2:remove()
						end
					end, 9 * 1000)
				end, 5 * 1000)
			elseif check2 then
				return false
			end
			addEvent(function()
				activateGeyser()
			end, 1 * 1000)
		end, 8 * 1000)
	end
	return true
end

local cultsOfTibiaLevers = Action()

function cultsOfTibiaLevers.onUse(player, item, fromPosition, itemEx, toPosition)
	local players = {}
	local ittable = {}
	local blockmonsters = { "Leiden", "Wine Cask", "Liquor Spirit", "Ravenous Hunger" }
	local convertTable = {}
	item:transform(transformid[item:getId()])

	if item:getActionId() == 5501 and item:getId() == 8912 then
		if player:getPosition() == Position(33138, 31953, 15) then
			local teleport = 0
			local playersInArea = {}
			local frompos = Position(33151, 31942, 15)
			local topos = Position(33176, 31966, 15)

			for i = 31953, 31957 do
				local newpos = Position(33138, i, 15)
				local nplayer = Tile(newpos):getTopCreature()
				if nplayer and nplayer:isPlayer() then
					teleport = teleport + 1
					table.insert(playersInArea, nplayer)
				end
			end

			if isPlayerInArea(frompos, topos) then
				player:sendCancelMessage("The room is full.")
				return true
			end

			for _x = frompos.x, topos.x, 1 do
				for _y = frompos.y, topos.y, 1 do
					for _z = frompos.z, topos.z, 1 do
						local tile = Tile(Position(_x, _y, _z))
						if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() then
							tile:getTopCreature():remove()
						end
					end
				end
			end

			for _, nplayer in ipairs(playersInArea) do
				nplayer:setBossCooldown("Ravenous Hunger", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
				nplayer:teleportTo(Position(33161, 31959, 15), true)
				nplayer:sendBosstiaryCooldownTimer()
				convertTable[#convertTable + 1] = nplayer:getId()
				nplayer:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end

			Game.createMonster("Wine Cask", Position(33162, 31945, 15))
			local leiden = Game.createMonster("Leiden", Position(33162, 31950, 15))
			leiden:setHealth(leiden:getHealth() / 2)
			kickerPlayerRoomAfterMin(convertTable, frompos, topos, Position(33121, 31951, 15), "You were kicked for exceeding the time limit within the boss room.", "", 60, true, ittable, blockmonsters)
		end
	end

	if item:getActionId() == 5502 and item:getId() == 8912 then
		if player:getPosition() == Position(33162, 31893, 15) then
			local teleport = 0
			local playersInArea = {}
			local frompos = Position(33152, 31908, 15)
			local topos = Position(33175, 31923, 15)

			for i = 31893, 31897 do
				local newpos = Position(33162, i, 15)
				local nplayer = Tile(newpos):getTopCreature()
				if nplayer and nplayer:isPlayer() then
					teleport = teleport + 1
					table.insert(playersInArea, nplayer)
				end
			end

			if isPlayerInArea(frompos, topos) then
				player:sendCancelMessage("The room is full.")
				return true
			end

			for _x = frompos.x, topos.x, 1 do
				for _y = frompos.y, topos.y, 1 do
					for _z = frompos.z, topos.z, 1 do
						local tile = Tile(Position(_x, _y, _z))
						if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() then
							tile:getTopCreature():remove()
						end
					end
				end
			end

			for _, nplayer in ipairs(playersInArea) do
				nplayer:setBossCooldown("The False God", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
				nplayer:teleportTo(Position(33169, 31915, 15), true)
				convertTable[#convertTable + 1] = nplayer:getId()
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end

			transformMonster(25300, 1, "minotaur idol", Position(33157, 31910, 15), Position(33168, 31910, 15), 0)
			transformMonster(25300, 1, "minotaur idol", Position(33158, 31921, 15), Position(33168, 31921, 15), 6)
			addEvent(transformMonster, 13 * 15000, 3, 3, "Sphere Of Wrath", {}, {}, 0)
			Game.createMonster("The False God", Position(33159, 31914, 15))
			kickerPlayerRoomAfterMin(convertTable, frompos, topos, Position(33181, 31894, 15), "You were kicked for exceeding the time limit within the boss room.", "", 60, true, ittable, blockmonsters)
		end
	end

	if item:getActionId() == 5500 then
		if player:getPosition() == Position(33095, 31943, 15) and item:getId() == 8912 then
			local teleport = 0
			local playersInArea = {}
			local frompos = Position(33084, 31907, 15)
			local topos = Position(33114, 31933, 15)

			for i = 31943, 31947 do
				local newpos = Position(33095, i, 15)
				local nplayer = Tile(newpos):getTopCreature()
				if nplayer and nplayer:isPlayer() then
					teleport = teleport + 1
					table.insert(playersInArea, nplayer)
				end
			end

			if isPlayerInArea(frompos, topos) then
				player:sendCancelMessage("It looks like there is someone inside.")
				return true
			end

			for _x = frompos.x, topos.x, 1 do
				for _y = frompos.y, topos.y, 1 do
					for _z = frompos.z, topos.z, 1 do
						local tile = Tile(Position(_x, _y, _z))
						if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() then
							tile:getTopCreature():remove()
						end
					end
				end
			end

			for _, nplayer in ipairs(playersInArea) do
				nplayer:setBossCooldown("Essence of Malice", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
				nplayer:teleportTo(Position(33098, 31921, 15), true)
				convertTable[#convertTable + 1] = nplayer:getId()
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end

			kickerPlayerRoomAfterMin(convertTable, frompos, topos, Position(33091, 31963, 15), "You were kicked for exceeding the time limit within the boss room.", "", 60, true, ittable, blockmonsters)
			Game.createMonster("Pillar of Summoning", Position(33093, 31919, 15))
			Game.createMonster("Pillar of Death", Position(33098, 31915, 15))
			Game.createMonster("Pillar of Protection", Position(33103, 31919, 15))
			Game.createMonster("Pillar of Healing", Position(33101, 31925, 15))
			Game.createMonster("Pillar of Draining", Position(33095, 31925, 15))
			Game.createMonster("Dorokoll The Mystic STOP", Position(33095, 31924, 15)):registerEvent("HealthPillar")
			Game.createMonster("Eshtaba The Conjurer STOP", Position(33094, 31919, 15)):registerEvent("HealthPillar")
			Game.createMonster("Eliz The Unyielding STOP", Position(33102, 31919, 15)):registerEvent("HealthPillar")
			Game.createMonster("Mezlon The Defiler STOP", Position(33101, 31924, 15)):registerEvent("HealthPillar")
			Game.createMonster("Malkhar Deathbringer STOP", Position(33098, 31916, 15)):registerEvent("HealthPillar")
		end
	end

	if item:getActionId() == 5503 then
		if player:getPosition() == Position(33127, 31892, 15) and item:getId() == 8912 then
			local teleport = 0
			local playersInArea = {}
			local frompos = Position(33119, 31913, 15)
			local topos = Position(33142, 31936, 15)

			for i = 31892, 31896 do
				local newpos = Position(33127, i, 15)
				local nplayer = Tile(newpos):getTopCreature()
				if nplayer and nplayer:isPlayer() then
					teleport = teleport + 1
					table.insert(playersInArea, nplayer)
				end
			end

			if isPlayerInArea(frompos, topos) then
				player:sendCancelMessage("It looks like there is someone inside.")
				return true
			end

			for _x = frompos.x, topos.x, 1 do
				for _y = frompos.y, topos.y, 1 do
					for _z = frompos.z, topos.z, 1 do
						local tile = Tile(Position(_x, _y, _z))
						if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() then
							tile:getTopCreature():remove()
						end
					end
				end
			end

			for _, nplayer in ipairs(playersInArea) do
				nplayer:setBossCooldown("The Souldespoiler", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
				nplayer:teleportTo(Position(33130, 31919, 15), true)
				convertTable[#convertTable + 1] = nplayer:getId()
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end

			kickerPlayerRoomAfterMin(convertTable, frompos, topos, Position(33109, 31887, 15), "You were kicked for exceeding the time limit within the boss room.", "", 60, true, ittable, blockmonsters)
			Game.createMonster("The Sinister Hermit Dirty", Position(33131, 31925, 15))
			activateGeyser()
		end
	end

	if item:getActionId() == 5504 then
		if player:getPosition() == Position(33164, 31859, 15) and item:getId() == 8912 then
			local teleport = 0
			local playersInArea = {}
			local frompos = Position(33123, 31846, 15)
			local topos = Position(33149, 31871, 15)

			for y = 31859, 31863 do
				local newpos = Position(33164, y, 15)
				local nplayer = Tile(newpos):getTopCreature()
				if nplayer and nplayer:isPlayer() then
					teleport = teleport + 1
					table.insert(playersInArea, nplayer)
				end
			end

			if isPlayerInArea(frompos, topos) then
				player:sendCancelMessage("It looks like there is someone inside.")
				return true
			end

			for _x = frompos.x, topos.x, 1 do
				for _y = frompos.y, topos.y, 1 do
					for _z = frompos.z, topos.z, 1 do
						local tile = Tile(Position(_x, _y, _z))
						if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() then
							tile:getTopCreature():remove()
						end
					end
				end
			end

			for _, nplayer in ipairs(playersInArea) do
				nplayer:setBossCooldown("The Armored Voidborn", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
				nplayer:teleportTo(Position(33137, 31867, 15), true)
				convertTable[#convertTable + 1] = nplayer:getId()
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end

			local function createBeam1(fromPos, toPos, id, dir)
				if dir == 1 then
					for _x = fromPos.x, toPos.x, 1 do
						local tile = Tile(Position(_x, fromPos.y, fromPos.z))
						if tile and tile:getItemCountById(id) == 0 then
							Game.createItem(id, 1, Position(_x, fromPos.y, fromPos.z))
						end
					end
				elseif dir == 2 then
					for _y = fromPos.y, toPos.y, 1 do
						local tile = Tile(Position(fromPos.x, _y, fromPos.z))
						if tile and tile:getItemCountById(id) == 0 then
							Game.createItem(id, 1, Position(fromPos.x, _y, fromPos.z))
						end
					end
				end
			end

			local itemsToMonster = {
				Position(33133, 31856, 15),
				Position(33140, 31856, 15),
				Position(33140, 31863, 15),
				Position(33133, 31863, 15),
			}

			for _, position in pairs(itemsToMonster) do
				local tile = Tile(position)
				if tile and tile:getItemCountById(7805) < 1 then
					Game.createItem(7805, 1, position)
				end
			end

			createBeam1(Position(33134, 31856, 15), Position(33139, 31856, 15), 6116, 1)
			createBeam1(Position(33134, 31863, 15), Position(33139, 31863, 15), 6116, 1)
			createBeam1(Position(33140, 31857, 15), Position(33140, 31862, 15), 6117, 2)
			createBeam1(Position(33133, 31857, 15), Position(33133, 31862, 15), 6117, 2)

			Game.createMonster("Security Golem", Position(33131, 31855, 15))
			Game.createMonster("Security Golem", Position(33142, 31855, 15))
			Game.createMonster("Security Golem", Position(33141, 31863, 15))
			Game.createMonster("Security Golem", Position(33132, 31863, 15))

			Game.createMonster("Containment Machine", Position(33133, 31864, 15)):registerEvent("MachineDeath")
			Game.createMonster("The Armored Voidborn", Position(33135, 31859, 15)):registerEvent("MachineDeath")
			kickerPlayerRoomAfterMin(convertTable, frompos, topos, Position(33179, 31840, 15), "You were kicked for exceeding the time limit within the boss room.", "", 60, true, ittable, blockmonsters)
		end
	end

	if item:getActionId() == 5505 then
		if player:getPosition() == Position(33507, 32228, 10) and item:getId() == 8912 then
			local teleport = 0
			local teleport = 0
			local playersInArea = {}
			local frompos = Position(33087, 31848, 15)
			local topos = Position(33109, 31871, 15)

			for _y = 32228, 32232 do
				local newpos = Position(33507, _y, 10)
				local nplayer = Tile(newpos):getTopCreature()
				if nplayer and nplayer:isPlayer() then
					teleport = teleport + 1
					table.insert(playersInArea, nplayer)
				end
			end

			if isPlayerInArea(frompos, topos) then
				player:sendCancelMessage("It looks like there is someone inside.")
				return true
			end

			for _x = frompos.x, topos.x, 1 do
				for _y = frompos.y, topos.y, 1 do
					for _z = frompos.z, topos.z, 1 do
						local tile = Tile(Position(_x, _y, _z))
						if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() then
							tile:getTopCreature():remove()
						end
						if tile then
							local tileItems = tile:getItems()
							if type(tileItems) == "table" and #tileItems > 0 then
								for _, it in pairs(tileItems) do
									if ItemType(it:getId()):isCorpse() then
										it:remove()
									end
								end
							end
						end
					end
				end
			end

			for _, nplayer in ipairs(playersInArea) do
				nplayer:setBossCooldown("The Sandking", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
				nplayer:teleportTo(Position(33099, 31864, 15), true)
				convertTable[#convertTable + 1] = nplayer:getId()
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end

			Game.createMonster("the sandking fake", Position(33099, 31858, 15)):registerEvent("SandkingThink")
			Game.setStorageValue("sandking", 1)
			kickerPlayerRoomAfterMin(convertTable, frompos, topos, Position(33459, 32269, 10), "You were kicked for exceeding the time limit within the boss room.", "", 60, true, ittable, blockmonsters)
		end
	end

	if item:getActionId() == 5506 then
		if player:getPosition() == Position(33074, 31884, 15) and item:getId() == 8912 then
			local teleport = 0
			local playersInArea = {}
			local frompos = Position(33023, 31904, 14)
			local topos = Position(33052, 31932, 15)

			if player:getPosition() == Position(33074, 31884, 15) then
				teleport = teleport + 1
				table.insert(playersInArea, player)
			else
				return true
			end

			local pt1 = Position(33073, 31885, 15)
			local pt2 = Position(33075, 31887, 15)
			for _x = pt1.x, pt2.x do
				for _y = pt1.y, pt2.y do
					local nplayer = Tile(Position(_x, _y, 15)):getTopCreature()
					if nplayer and nplayer:isPlayer() then
						teleport = teleport + 1
						table.insert(playersInArea, nplayer)
					end
				end
			end

			if isPlayerInArea(frompos, topos) then
				player:sendCancelMessage("It looks like there is someone inside.")
				return true
			end

			for _x = frompos.x, topos.x do
				for _y = frompos.y, topos.y do
					for _z = frompos.z, topos.z do
						local tile = Tile(Position(_x, _y, _z))
						if tile and tile:getTopCreature() and tile:getTopCreature():isMonster() then
							tile:getTopCreature():remove()
						end
						if tile then
							local tileItems = tile:getItems()
							if type(tileItems) == "table" and #tileItems > 0 then
								for _, it in pairs(tileItems) do
									if ItemType(it:getId()):isCorpse() then
										it:remove()
									end
								end
							end
						end
					end
				end
			end

			for _, nplayer in ipairs(playersInArea) do
				nplayer:setBossCooldown("The Source Of Corruption", os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN))
				nplayer:teleportTo(Position(33039, 31925, 15), true)
				nplayer:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end

			Game.createMonster("The Remorseless Corruptor", Position(33039, 31922, 15))
			Game.createMonster("Zarcorix Of Yalahar", Position(33039, 31921, 15)):registerEvent("YalahariHealth")
			Game.createMonster("Stolen Soul", Position(33039, 31920, 15))
			Game.createMonster("Soul Reaper", Position(33039, 31919, 15))
			spawnDarkSoul(1, 30)
			spawnDarkSoul(2, 30)
			spawnStolenSoul(30)

			kickerPlayerRoomAfterMin(playersInArea, frompos, topos, Position(33072, 31867, 15), "You were kicked for exceeding the time limit within the boss room.", "", 60, true, ittable, blockmonsters)
		end
	end

	return true
end

cultsOfTibiaLevers:aid(5500, 5501, 5502, 5503, 5504, 5505, 5506)
cultsOfTibiaLevers:register()
