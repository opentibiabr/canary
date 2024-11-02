local questlog = {
	[1] = {
		bossName = "Faceless Bane",
		storageQuestline = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedralGlobal.FacelessTime,
		middlePosition = Position(33617, 32563, 13),
		maxValue = 4,
	},
	[2] = {
		bossName = "Maxxenius",
		storageQuestline = Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount,
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.MaxxeniusTimer,
		middlePosition = Position(32208, 32048, 14),
		maxValue = 5,
	},
	[3] = {
		bossName = "Alptramun",
		storageQuestline = Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount,
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.AlptramunTimer,
		middlePosition = Position(32208, 32048, 14),
		maxValue = 5,
	},
	[4] = {
		bossName = "Izcandar the Banished",
		storageQuestline = Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount,
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.IzcandarTimer,
		middlePosition = Position(32208, 32048, 14),
		maxValue = 5,
	},
	[5] = {
		bossName = "Izcandar Champion of Winter",
		storageQuestline = Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount,
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.IzcandarTimer,
		middlePosition = Position(32208, 32048, 14),
		maxValue = 5,
	},
	[6] = {
		bossName = "Izcandar Champion of Summer",
		storageQuestline = Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount,
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.IzcandarTimer,
		middlePosition = Position(32208, 32048, 14),
		maxValue = 5,
	},
	[7] = {
		bossName = "Plagueroot",
		storageQuestline = Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount,
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.PlagueRootTimer,
		middlePosition = Position(32208, 32048, 14),
		maxValue = 5,
	},
	[8] = {
		bossName = "Malofur Mangrinder",
		storageQuestline = Storage.Quest.U12_00.TheDreamCourts.DreamScar.BossCount,
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.MalofurTimer,
		middlePosition = Position(32208, 32048, 14),
		maxValue = 5,
	},
	[9] = {
		bossName = "The Nightmare Beast",
		storageQuestline = Storage.Quest.U12_00.TheDreamCourts.WardStones.Questline,
		storageTimer = Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.NightmareTimer,
		middlePosition = Position(32207, 32045, 15),
		maxValue = 2,
	},
}

local alptramunSummons = {
	[1] = {
		name = "unpleasant dream",
		minValue = 0,
		maxValue = 9,
	},
	[2] = {
		name = "horrible dream",
		minValue = 9,
		maxValue = 18,
	},
	[3] = {
		name = "nightmarish dream",
		minValue = 18,
		maxValue = 27,
	},
	[4] = {
		name = "mind-wrecking dream",
		minValue = 27,
		maxValue = 36,
	},
}

local creaturescripts_dreamCourtsDeath = CreatureEvent("dreamCourtsDeath")

function creaturescripts_dreamCourtsDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified)
	if not creature:isMonster() or creature:getMaster() then
		return true
	end

	local cName = creature:getName()

	if cName:lower() == "plant abomination" then
		local cPos = creature:getPosition()
		Game.createMonster("plant attendant", cPos)
	end

	for _, k in pairs(questlog) do
		if cName == k.bossName then
			for pid, _ in pairs(creature:getDamageMap()) do
				local attackerPlayer = Player(pid)

				if attackerPlayer then
					if attackerPlayer:getStorageValue(k.storageQuestline) <= k.maxValue then
						attackerPlayer:setStorageValue(k.storageQuestline, attackerPlayer:getStorageValue(k.storageQuestline) + 1)
					end
					attackerPlayer:setStorageValue(k.storageTimer, os.time() + 20 * 60 * 60)
				end
			end

			if cName:lower() == "alptramun" then
				Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.AlptramunSummonsKilled, 0)
			end
		end
	end

	local summonsKilled = Game.getStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.AlptramunSummonsKilled)

	for _, k in pairs(alptramunSummons) do
		if cName:lower() == k.name then
			if summonsKilled >= k.minValue and summonsKilled <= k.maxValue then
				Game.setStorageValue(Storage.Quest.U12_00.TheDreamCourts.DreamScarGlobal.AlptramunSummonsKilled, summonsKilled + 1)
			end
		end
	end

	return true
end

creaturescripts_dreamCourtsDeath:register()
