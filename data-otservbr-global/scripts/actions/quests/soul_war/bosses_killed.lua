local bosses = {
	["goshnar's malice"] = {storage = Storage.Quest.U12_40.SoulWar.GoshnarMaliceKilled},
	["goshnar's hatred"] = {storage = Storage.Quest.U12_40.SoulWar.GoshnarHatredKilled},
	["goshnar's spite"] = {storage = Storage.Quest.U12_40.SoulWar.GoshnarSpiteKilled},
	["goshnar's cruelty"] = {storage = Storage.Quest.U12_40.SoulWar.GoshnarCrueltyKilled},
	["goshnar's greed"] = {storage = Storage.Quest.U12_40.SoulWar.GoshnarGreedKilled},
	["goshnar's megalomania"] = {storage = Storage.Quest.U12_40.SoulWar.GoshnarMegalomaniaKilled},
}

local bossesSoulWar = CreatureEvent("SoulWarKill")
function bossesSoulWar.onKill(creature, target)
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
bossesSoulWar:register()