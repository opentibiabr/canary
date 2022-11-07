local bosses = {
	['jaul'] = {status = 2, storage = Storage.DeeplingBosses.Jaul},
	['tanjis'] = {status = 3, storage = Storage.DeeplingBosses.Tanjis},
	['obujos'] = {status = 4, storage = Storage.DeeplingBosses.Obujos},
}

local deeplingBosses = CreatureEvent("DeeplingBosses")
function deeplingBosses.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossConfig = bosses[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end

	for pid, _ in pairs(targetMonster:getDamageMap()) do
		local attackerPlayer = Player(pid)
		if attackerPlayer then
			if attackerPlayer:getStorageValue(Storage.DeeplingBosses.DeeplingStatus) < bossConfig.status then
				attackerPlayer:setStorageValue(Storage.DeeplingBosses.DeeplingStatus, bossConfig.status)
			end
			attackerPlayer:setStorageValue(bossConfig.storage, 1)
		end
	end
end

deeplingBosses:register()
