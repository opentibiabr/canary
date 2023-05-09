local bosses = {
	["the fear feaster"] = {storage = Storage.Quest.U12_30.FeasterOfSouls.FearFeasterKilled},
	["the dread maiden"] = {storage = Storage.Quest.U12_30.FeasterOfSouls.DreadMaidenKilled},
	["the unwelcome"] = {storage = Storage.Quest.U12_30.FeasterOfSouls.UnwelcomeKilled},
	["the pale worm"] = {storage = Storage.Quest.U12_30.FeasterOfSouls.PaleWormKilled},
}

local bossesFeasterOfSouls = CreatureEvent("FeasterOfSoulsKill")
function bossesFeasterOfSouls.onKill(creature, target)
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
bossesFeasterOfSouls:register()