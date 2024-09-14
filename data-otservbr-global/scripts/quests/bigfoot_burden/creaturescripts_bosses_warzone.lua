local bosses = {
	["deathstrike"] = { status = 2, storage = Storage.Quest.U9_60.BigfootsBurden.Warzone1Reward },
	["gnomevil"] = { status = 3, storage = Storage.Quest.U9_60.BigfootsBurden.Warzone2Reward },
	["abyssador"] = { status = 4, storage = Storage.Quest.U9_60.BigfootsBurden.Warzone3Reward },
}

-- This will set the status of warzone (killing 1, 2 and 3 wz bosses in order you can open the chest and get "some golden fruits") and the reward chest storages
local bossesWarzone = CreatureEvent("BossesWarzoneDeath")
function bossesWarzone.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		if (player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.WarzoneStatus) + 1) == bossConfig.status then
			player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.WarzoneStatus, bossConfig.status)
			if bossConfig.status == 4 then
				player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.DoorGoldenFruits, 1)
			end
		end
		player:setStorageValue(bossConfig.storage, 1)
		player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.BossKills, player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.BossKills) + 1)
	end)
	return true
end

bossesWarzone:register()
