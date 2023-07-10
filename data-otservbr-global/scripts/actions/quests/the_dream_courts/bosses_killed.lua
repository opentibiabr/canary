local bosses = {
	["plagueroot"] = {storage = Storage.Quest.U12_00.TheDreamCourts.PlaguerootKilled},
	["malofur mangrinder"] = {storage = Storage.Quest.U12_00.TheDreamCourts.MalofurKilled},
	["maxxenius"] = {storage = Storage.Quest.U12_00.TheDreamCourts.MaxxeniusKilled},
	["alptramun"] = {storage = Storage.Quest.U12_00.TheDreamCourts.AlptramunKilled},
	["izcandar the banished"] = {storage = Storage.Quest.U12_00.TheDreamCourts.IzcandarKilled},
	["the nightmare beast"] = {storage = Storage.Quest.U12_00.TheDreamCourts.NightmareBeastKilled},
}

local bossesDreamCourts = CreatureEvent("DreamCourtsKill")
function bossesDreamCourts.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster or targetMonster:getMaster() then
		return true
	end
	local bossConfig = bosses[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end
	for key, value in pairs(targetMonster:getDamageMap()) do
		local attackerPlayer = Player(key)
		if attackerPlayer then
			if bossConfig.storage then
				attackerPlayer:setStorageValue(bossConfig.storage, 1)
			end
		end
	end
	return true
end
bossesDreamCourts:register()