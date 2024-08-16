local bosses = {
	["plagueroot"] = { storage = Storage.Quest.U12_00.TheDreamCourts.PlaguerootKilled },
	["malofur mangrinder"] = { storage = Storage.Quest.U12_00.TheDreamCourts.MalofurKilled },
	["maxxenius"] = { storage = Storage.Quest.U12_00.TheDreamCourts.MaxxeniusKilled },
	["alptramun"] = { storage = Storage.Quest.U12_00.TheDreamCourts.AlptramunKilled },
	["izcandar the banished"] = { storage = Storage.Quest.U12_00.TheDreamCourts.IzcandarKilled },
	["the nightmare beast"] = { storage = Storage.Quest.U12_00.TheDreamCourts.NightmareBeastKilled },
}

local bossesDreamCourts = CreatureEvent("DreamCourtsBossDeath")
function bossesDreamCourts.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end
	onDeathForDamagingPlayers(creature, function(creature, player)
		if bossConfig.storage then
			player:setStorageValue(bossConfig.storage, 1)
		end
	end)
	return true
end

bossesDreamCourts:register()
