local bosses = {
	["deathstrike"] = { status = 2, storage = Storage.BigfootBurden.Warzone1Reward },
	["gnomevil"] = { status = 3, storage = Storage.BigfootBurden.Warzone2Reward },
	["abyssador"] = { status = 4, storage = Storage.BigfootBurden.Warzone3Reward },
}

-- This will set the status of warzone (killing 1, 2 and 3 wz bosses in order you can open the chest and get "some golden fruits") and the reward chest storages
local bossesWarzone = CreatureEvent("BossesWarzoneDeath")
function bossesWarzone.onDeath(target)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		if (player:getStorageValue(Storage.BigfootBurden.WarzoneStatus) + 1) == bossConfig.status then
			player:setStorageValue(Storage.BigfootBurden.WarzoneStatus, bossConfig.status)
			if bossConfig.status == 4 then
				player:setStorageValue(Storage.BigfootBurden.DoorGoldenFruits, 1)
			end
		end
		player:setStorageValue(bossConfig.storage, 1)
		player:setStorageValue(Storage.BigfootBurden.BossKills, player:getStorageValue(Storage.BigfootBurden.BossKills) + 1)
	end)
	return true
end

bossesWarzone:register()
