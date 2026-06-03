local fugueKill = CreatureEvent("FugueKill")

function fugueKill.onDeath(creature, corpse, lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission) == 2 then
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission, 3)
		end
		player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.FugueSpawned, 0)
	end)
	return true
end

fugueKill:register()
