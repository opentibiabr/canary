local deerKill = CreatureEvent("DeerKill")

function deerKill.onDeath(creature, corpse, lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local kills = player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.DalKills)
		if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.DalTask) == 1 and kills < 20 then
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.DalKills, kills + 1)
		end
	end)
	return true
end

deerKill:register()
