local transform = {
	[9110] = 9111,
	[9111] = 9110
}

local bossNames = {
	"plagueroot", "izcandar the banished", "izcandar champion of summer", "izcandar champion of winter"
}

local leverInfo = {
	[1] = {
		byDay = "Monday",
		bossName = "Alptramun",
		bossPosition = Position(32208, 32048, 14),
		leverPosition = Position(32208, 32020, 13),
		pushPosition = Position(32208, 32021, 13),
		leverFromPos = Position(32208, 32021, 13),
		leverToPos = Position(32208, 32025, 13),
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.alptramunTimer,
		roomFromPosition = Position(32198, 32037, 14),
		roomToPosition = Position(32234, 32054, 14),
		teleportTo = Position(32224, 32048, 14),
		typePush = "y",
		exitPosition = Position(32208, 32035, 13),
		globalTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.alptramunTimer
	},
	[2] = {
		byDay = "Tuesday",
		bossName = "Izcandar the Banished",
		bossPosition = Position(32208, 32048, 14),
		leverPosition = Position(32208, 32020, 13),
		pushPosition = Position(32208, 32021, 13),
		leverFromPos = Position(32208, 32021, 13),
		leverToPos = Position(32208, 32025, 13),
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.izcandarTimer,
		roomFromPosition = Position(32198, 32037, 14),
		roomToPosition = Position(32234, 32054, 14),
		teleportTo = Position(32224, 32048, 14),
		typePush = "y",
		exitPosition = Position(32208, 32035, 13),
		globalTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.izcandarTimer
	},
	[3] = {
		byDay = "Wednesday",
		bossName = "Malofur Mangrinder",
		bossPosition = Position(32208, 32048, 14),
		leverPosition = Position(32208, 32020, 13),
		pushPosition = Position(32208, 32021, 13),
		leverFromPos = Position(32208, 32021, 13),
		leverToPos = Position(32208, 32025, 13),
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.malofurTimer,
		roomFromPosition = Position(32198, 32037, 14),
		roomToPosition = Position(32234, 32054, 14),
		teleportTo = Position(32224, 32048, 14),
		typePush = "y",
		exitPosition = Position(32208, 32035, 13),
		globalTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.malofurTimer
	},
	[4] = {
		byDay = "Thursday",
		bossName = "Maxxenius",
		bossPosition = Position(32208, 32048, 14),
		leverPosition = Position(32208, 32020, 13),
		pushPosition = Position(32208, 32021, 13),
		leverFromPos = Position(32208, 32021, 13),
		leverToPos = Position(32208, 32025, 13),
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.maxxeniusTimer,
		roomFromPosition = Position(32198, 32037, 14),
		roomToPosition = Position(32234, 32054, 14),
		teleportTo = Position(32224, 32048, 14),
		typePush = "y",
		exitPosition = Position(32208, 32035, 13),
		globalTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.maxxeniusTimer
	},
	[5] = {
		byDay = "Friday",
		bossName = "Izcandar the Banished",
		bossPosition = Position(32208, 32048, 14),
		leverPosition = Position(32208, 32020, 13),
		pushPosition = Position(32208, 32021, 13),
		leverFromPos = Position(32208, 32021, 13),
		leverToPos = Position(32208, 32025, 13),
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.izcandarTimer,
		roomFromPosition = Position(32198, 32037, 14),
		roomToPosition = Position(32234, 32054, 14),
		teleportTo = Position(32224, 32048, 14),
		typePush = "y",
		exitPosition = Position(32208, 32035, 13),
		globalTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.izcandarTimer
	},
	[6] = {
		byDay = "Saturday",
		bossName = "Plagueroot",
		bossPosition = Position(32208, 32048, 14),
		leverPosition = Position(32208, 32020, 13),
		pushPosition = Position(32208, 32021, 13),
		leverFromPos = Position(32208, 32021, 13),
		leverToPos = Position(32208, 32025, 13),
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.plaguerootTimer,
		roomFromPosition = Position(32198, 32037, 14),
		roomToPosition = Position(32234, 32054, 14),
		teleportTo = Position(32224, 32048, 14),
		typePush = "y",
		exitPosition = Position(32208, 32035, 13),
		globalTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.plaguerootTimer
	},
	[7] = {
		byDay = "Sunday",
		bossName = "Maxxenius",
		bossPosition = Position(32208, 32048, 14),
		leverPosition = Position(32208, 32020, 13),
		pushPosition = Position(32208, 32021, 13),
		leverFromPos = Position(32208, 32021, 13),
		leverToPos = Position(32208, 32025, 13),
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.maxxeniusTimer,
		roomFromPosition = Position(32198, 32037, 14),
		roomToPosition = Position(32234, 32054, 14),
		teleportTo = Position(32224, 32048, 14),
		typePush = "y",
		exitPosition = Position(32208, 32035, 13),
		globalTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.maxxeniusTimer
	},
}

local function spawnSummons(k, monsterName, eventName, timing, positionTable, middlePosition)
	local spectators = Game.getSpectators(middlePosition, false, false, 20, 20, 20, 20)
	local maySummon = false
	local hasPlayer = false

	for _, c in pairs(spectators) do
		for i = 1, #bossNames do
			if c and (c:getName():lower() == bossNames[i]) then
				maySummon = true
			end
			if c:isPlayer() then
				hasPlayer = true
			end
		end
	end

	if maySummon and hasPlayer then
		if k <= 4 then
			for i = 1, #positionTable do
				local sqm = positionTable[i]
				if sqm then	sqm:sendMagicEffect(CONST_ME_TELEPORT)	end
			end
			k = k + 1
			addEvent(spawnSummons, 2*1000, k, monsterName, eventName, timing, positionTable, middlePosition)
		else
			for i = 1, #positionTable do
				local monster = Game.createMonster(monsterName, positionTable[i], true, true)
				if monster and eventName then monster:registerEvent(eventName) end
			end
			addEvent(function()
				spawnSummons(1, monsterName, eventName, timing, positionTable, middlePosition)
			end, timing * 1000)
		end
	end
end

local whirlingBlades = {
	Position(32200, 32046, 14),
	Position(32200, 32050, 14),
	Position(32202, 32049, 14),
	Position(32202, 32051, 14),
	Position(32205, 32043, 14),
	Position(32200, 32050, 14),
	Position(32205, 32048, 14),
	Position(32205, 32055, 14),
	Position(32206, 32051, 14),
	Position(32206, 32040, 14),
	Position(32207, 32043, 14),
	Position(32207, 32048, 14),
	Position(32208, 32051, 14),
	Position(32209, 32048, 14),
	Position(32209, 32055, 14),
	Position(32210, 32051, 14),
	Position(32211, 32042, 14),
	Position(32211, 32044, 14),
	Position(32211, 32046, 14),
	Position(32214, 32043, 14),
	Position(32214, 32049, 14),
	Position(32214, 32049, 14),
	Position(32213, 32052, 14)
}

local plantAttendants = {
	Position(32204, 32047, 14),
	Position(32212, 32043, 14),
	Position(32212, 32050, 14)
}

local coldOfWinter = {
	Position(32211, 32042, 14),
	Position(32214, 32048, 14),
	Position(32210, 32053, 14),
}

local heatOfSummer = {
	Position(32204, 32053, 14),
	Position(32201, 32047, 14),
	Position(32204, 32043, 14),
}

local lastBoss = {
	bossName = "The Nightmare Beast",
	bossPosition = Position(32209, 32044, 15),
	storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.nightmareTimer,
	globalTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScar.nightmareTimer,
	fromPositionTeleport = Position(32210, 32070, 15),
	toPositionTeleport = Position(32214, 32071, 15),
	fromPositionPush = Position(32211, 32070, 15),
	toPositionPush = Position(32213, 32070, 15),
	teleportTo = Position(32208, 32051, 15),
	roomFromPosition = Position(32194, 32035, 15),
	roomToPosition = Position(32223, 32058, 15),
	exitPosition = Position(32212, 32084, 15),
}

local function startFight(middle, where)
	local newPos = Position(where.x, where.y + 5, where.z)
	local spectators = Game.getSpectators(middle, false, true, 9, 9, 9, 9)

	for _, p in pairs(spectators) do
		if p and p:isPlayer() then
			p:teleportTo(newPos)
		end
	end
end

local actions_dreamscarLevers = Action()

function actions_dreamscarLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local playersTable = {}
	local iPos = item:getPosition()
	local pPos = player:getPosition()
	local nightmareLever = Position(32212, 32069, 15)

	if item.itemid == 9110 then
		if iPos == nightmareLever then
			if player:doCheckBossRoom(lastBoss.bossName, lastBoss.roomFromPosition, lastBoss.roomToPosition) then
				if pPos:isInRange(lastBoss.fromPositionPush, lastBoss.toPositionPush) then
					for x = lastBoss.fromPositionTeleport.x, lastBoss.toPositionTeleport.x do
						for y = lastBoss.fromPositionTeleport.y, lastBoss.toPositionTeleport.y do
							local c = Tile(Position(x, y, 15)):getTopCreature()
							if c and c:isPlayer() then
								table.insert(playersTable, c:getId())
								c:teleportTo(lastBoss.teleportTo)
								c:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
								c:setStorageValue(lastBoss.storageTimer, os.time() + 20*60*60)
							end
						end
					end

					local monster = Game.createMonster(lastBoss.bossName, lastBoss.bossPosition, true, true)

					if monster then
						monster:registerEvent('dreamCourtsDeath')
					end

					Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.lastBossCurse, 0)

					addEvent(kickPlayersAfterTime, 30*60*1000, playersTable, lastBoss.roomFromPosition, lastBoss.roomToPosition, lastBoss.exitPosition)
				else
					return true
				end
			end
		else
			for i = 1, #leverInfo do
				if iPos == leverInfo[i].leverPosition and os.sdate("%A") == leverInfo[i].byDay then
					local leverTable = leverInfo[i]
					if pPos == leverTable.pushPosition then
						if player:doCheckBossRoom(leverTable.bossName, leverTable.roomFromPosition, leverTable.roomToPosition) then
							if leverTable.typePush == "x" then
								for i = leverTable.leverFromPos.x, leverTable.leverToPos.x do
									local newPos = Position(i, leverTable.leverFromPos.y, leverTable.leverFromPos.z)
									local creature = Tile(newPos):getTopCreature()
									if creature and creature:isPlayer() then
										creature:teleportTo(leverTable.teleportTo, true)
										creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
										creature:setStorageValue(leverTable.storageTimer, os.time() + 20*60*60)
										table.insert(playersTable, creature:getId())
									end
								end
							elseif leverTable.typePush == "y" then
								for i = leverTable.leverFromPos.y, leverTable.leverToPos.y do
									local newPos = Position(leverTable.leverFromPos.x, i, leverTable.leverFromPos.z)
									local creature = Tile(newPos):getTopCreature()
									if creature and creature:isPlayer() then
										creature:teleportTo(leverTable.teleportTo, true)
										creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
										creature:setStorageValue(leverTable.storageTimer, os.time() + 20*60*60)
										table.insert(playersTable, creature:getId())
									end
								end
							end

							local monster = Game.createMonster(leverTable.bossName, leverTable.bossPosition, true, true)

							if monster then
								if leverTable.bossName:lower() == "maxxenius" then
									local generators = {
										Position(32205, 32048, 14),
										Position(32210, 32045, 14),
										Position(32210, 32051, 14)
									}

									for i = 1, #generators do
										Game.createMonster("Generator", generators[i], true, true)
									end

									monster:registerEvent("facelessHealth")
								elseif leverTable.bossName:lower() == "alptramun" then
									for i = 1, 2 do
										local summon = Game.createMonster("unpleasant dream", leverTable.bossPosition, true, true)
										summon:registerEvent("dreamCourtsDeath")
									end

									Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.alptramunSummonsKilled, 0)

									monster:registerEvent("facelessHealth")
								elseif leverTable.bossName:lower() == "izcandar the banished" then
									monster:registerEvent("izcandarThink")

									spawnSummons(1, "the heat of summer", false, 15, heatOfSummer, leverTable.bossPosition)
									spawnSummons(1, "the cold of winter", false, 15, coldOfWinter, leverTable.bossPosition)

									Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScar.izcandarOutfit, 0)
								elseif leverTable.bossName:lower() == "plagueroot" then
									spawnSummons(1, "plant attendant", false, 15, plantAttendants, leverTable.bossPosition)

									monster:registerEvent("facelessHealth")
								elseif leverTable.bossName:lower() == "malofur mangrinder" then
									for i = 1, #whirlingBlades do
										local blade = Game.createMonster("whirling blades", whirlingBlades[i], true, true)
									end
								end

								monster:registerEvent("dreamCourtsDeath")

								addEvent(startFight, 30 * 1000, leverTable.teleportTo, leverTable.bossPosition)
							end

							addEvent(kickPlayersAfterTime, 30*60*1000, playersTable, leverTable.roomFromPosition, leverTable.roomToPosition, leverTable.exitPosition)
						end
					end
				end
			end
		end
	end

	item:transform(transform[item.itemid])

	return true
end

actions_dreamscarLevers:aid(23112)
actions_dreamscarLevers:register()
