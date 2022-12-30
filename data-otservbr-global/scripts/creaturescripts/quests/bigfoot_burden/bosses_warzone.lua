local bosses = {
	['deathstrike'] = {status = 2, storage = Storage.BigfootBurden.Warzone1Reward},
	['gnomevil'] = {status = 3, storage = Storage.BigfootBurden.Warzone2Reward},
	['abyssador'] = {status = 4, storage = Storage.BigfootBurden.Warzone3Reward},
}

-- This will set the status of warzone (killing 1, 2 and 3 wz bosses in order you can open the chest and get "some golden fruits") and the reward chest storages
local bossesWarzone = CreatureEvent("BossesWarzone")
function bossesWarzone.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossConfig = bosses[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end

	for index, value in pairs(targetMonster:getDamageMap()) do
		local attackerPlayer = Player(index)
		if attackerPlayer then
			if (attackerPlayer:getStorageValue(Storage.BigfootBurden.WarzoneStatus) + 1) == bossConfig.status then
				attackerPlayer:setStorageValue(Storage.BigfootBurden.WarzoneStatus, bossConfig.status)
				if bossConfig.status == 4 then
					attackerPlayer:setStorageValue(Storage.BigfootBurden.DoorGoldenFruits, 1)
				end
			end
			attackerPlayer:setStorageValue(bossConfig.storage, 1)
			attackerPlayer:setStorageValue(Storage.BigfootBurden.BossKills, attackerPlayer:getStorageValue(Storage.BigfootBurden.BossKills) + 1)
		end
	end
end

bossesWarzone:register()
