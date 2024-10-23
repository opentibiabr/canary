local mazzinorSummons = {
	name = "Wild Knowledge",
	eventName = "mazzinorDeath",
	middlePosition = Position(32724, 32720, 10),
	timing = 25,
	positions = {
		[1] = Position(32719, 32718, 10),
		[2] = Position(32723, 32719, 10),
		[3] = Position(32728, 32718, 10),
		[4] = Position(32724, 32724, 10),
	},
}

local ghuloshSummons = {
	name = "Bone Jaw",
	eventName = "",
	middlePosition = Position(32756, 32721, 10),
	timing = 25,
	positions = {
		[1] = Position(32755, 32721, 10),
	},
}

local gorzindelSummons = {
	name = "Mean Minion",
	name2 = "Malicious Minion",
	eventName = "",
	middlePosition = Position(32687, 32719, 10),
	timing = 25,
	positions = {
		[1] = Position(32687, 32717, 10),
	},
	positions2 = {
		[1] = Position(32687, 32720, 10),
	},
	tomesPosition = {
		[1] = { name = "stolen knowledge of armor", position = Position(32687, 32707, 10) },
		[2] = { name = "stolen knowledge of summoning", position = Position(32698, 32715, 10) },
		[3] = { name = "stolen knowledge of lifesteal", position = Position(32693, 32729, 10) },
		[4] = { name = "stolen knowledge of spells", position = Position(32681, 32729, 10) },
		[5] = { name = "stolen knowledge of healing", position = Position(32676, 32715, 10) },
	},
}

local lokathmorSummons = {
	name = "Knowledge Raider",
	eventName = "",
	middlePosition = Position(32751, 32689, 10),
	timing = 25,
	positions = {
		[1] = Position(32747, 32684, 10),
		[2] = Position(32755, 32684, 10),
		[3] = Position(32755, 32694, 10),
		[4] = Position(32747, 32694, 10),
	},
}

local bossNames = { "mazzinor", "supercharged mazzinor", "lokathmor", "ghulosh", "ghuloshz' deathgaze", "gorzindel", "stolen tome of portals" }

local function spawnSummons(k, monsterName, eventName, timing, positionTable, middlePosition, isGorzindel)
	local spectators = Game.getSpectators(middlePosition, false, false, 12, 12, 12, 12)
	local hasPlayer = false

	for _, c in pairs(spectators) do
		if c and c:isPlayer() then
			hasPlayer = true
		end
	end

	if isGorzindel then
		local hasTome = false
		for _, c in pairs(spectators) do
			for i = 1, #gorzindelSummons.tomesPosition do
				if c and (c:getName():lower() == gorzindelSummons.tomesPosition[i].name) then
					hasTome = true
				end
			end
		end
		if not hasTome then
			return false
		end
	end
	if hasPlayer then
		if k <= 4 then
			for i = 1, #positionTable do
				local sqm = positionTable[i]
				if sqm then
					sqm:sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
			k = k + 1
			addEvent(spawnSummons, 2 * 1000, k, monsterName, eventName, timing, positionTable, middlePosition, isGorzindel)
		else
			for i = 1, #positionTable do
				local monster = Game.createMonster(monsterName, positionTable[i])
				if monster then
					monster:registerEvent(eventName)
				end
			end
			addEvent(function()
				spawnSummons(1, monsterName, eventName, timing, positionTable, middlePosition, isGorzindel)
			end, timing * 1000)
		end
	end
end

local leverInfo = {
	[1] = { bossName = "Mazzinor", storage = Storage.Quest.U11_80.TheSecretLibrary.Library.MazzinorTimer, exit = Position(32616, 32532, 13), position = Position(32720, 32773, 10), type = "x", bossPosition = Position(32724, 32720, 10), teleportTo = Position(32724, 32726, 10), fromPosition = Position(32715, 32712, 10), toPosition = Position(32733, 32729, 10) },
	[2] = { bossName = "Lokathmor", storage = Storage.Quest.U11_80.TheSecretLibrary.Library.LokathmorTimer, exit = Position(32467, 32654, 12), position = Position(32720, 32749, 10), type = "x", bossPosition = Position(32751, 32689, 10), teleportTo = Position(32750, 32694, 10), fromPosition = Position(32741, 32680, 10), toPosition = Position(32759, 32697, 10) },
	[3] = { bossName = "Ghulosh", storage = Storage.Quest.U11_80.TheSecretLibrary.Library.GhuloshTimer, exit = Position(32659, 32713, 13), position = Position(32746, 32773, 10), type = "x", bossPosition = Position(32756, 32721, 10), teleportTo = Position(32755, 32727, 10), fromPosition = Position(32745, 32711, 10), toPosition = Position(32768, 32730, 10) },
	[4] = { bossName = "Gorzindel", storage = Storage.Quest.U11_80.TheSecretLibrary.Library.GorzindelTimer, exit = Position(32660, 32734, 12), position = Position(32746, 32749, 10), type = "x", bossPosition = Position(32685, 32717, 10), teleportTo = Position(32687, 32724, 10), fromPosition = Position(32671, 32703, 10), toPosition = Position(32702, 32734, 10) },
}

local actions_library_bossesLever = Action()

function actions_library_bossesLever.onUse(player, item, fromPosition, itemEx, toPosition)
	local playersTable = {}

	for _, lever in pairs(leverInfo) do
		if toPosition == lever.position then
			if player:doCheckBossRoom(lever.bossName, lever.fromPosition, lever.toPosition) then
				if lever.type == "x" then
					local startPos = lever.position.x + 1
					for x = startPos, startPos + 4 do
						local sqm = Tile(Position(x, lever.position.y, lever.position.z))
						if sqm then
							local c = sqm:getTopCreature()
							if c and c:isPlayer() then
								table.insert(playersTable, c:getId())
								c:teleportTo(lever.teleportTo)
								c:setStorageValue(lever.storage, os.time() + 20 * 60 * 60)
							end
						end
					end
				end

				local monster = Game.createMonster(lever.bossName, lever.bossPosition)

				if monster then
					if lever.bossName:lower() == "mazzinor" then
						addEvent(spawnSummons, 4 * 1000, 1, mazzinorSummons.name, mazzinorSummons.eventName, mazzinorSummons.timing, mazzinorSummons.positions, mazzinorSummons.middlePosition, false)
					elseif lever.bossName:lower() == "lokathmor" then
						addEvent(spawnSummons, 4 * 1000, 1, lokathmorSummons.name, lokathmorSummons.eventName, lokathmorSummons.timing, lokathmorSummons.positions, lokathmorSummons.middlePosition, false)
					elseif lever.bossName:lower() == "ghulosh" then
						addEvent(spawnSummons, 4 * 1000, 1, ghuloshSummons.name, ghuloshSummons.eventName, ghuloshSummons.timing, ghuloshSummons.positions, ghuloshSummons.middlePosition, false)
						local book = Game.createMonster("The Book of Death", Position(32755, 32716, 10))
						Game.setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Library.Ghulosh, 1)
					elseif lever.bossName:lower() == "gorzindel" then
						addEvent(spawnSummons, 4 * 1000, 1, gorzindelSummons.name, gorzindelSummons.eventName, gorzindelSummons.timing, gorzindelSummons.positions, gorzindelSummons.middlePosition, true)
						addEvent(spawnSummons, 4 * 1000, 1, gorzindelSummons.name2, gorzindelSummons.eventName, gorzindelSummons.timing, gorzindelSummons.positions2, gorzindelSummons.middlePosition, true)
						local tome = Game.createMonster("Stolen Tome of Portals", Position(32688, 32715, 10))
						for _, k in pairs(gorzindelSummons.tomesPosition) do
							local monster = Game.createMonster(k.name, k.position)
							local minion = Game.createMonster("Malicious Minion", k.position)
						end
					end
				end
				addEvent(kickPlayersAfterTime, 30 * 60 * 1000, playersTable, lever.fromPosition, lever.toPosition, lever.exit)
			end
		end
	end

	return true
end

actions_library_bossesLever:aid(4950)
actions_library_bossesLever:register()
