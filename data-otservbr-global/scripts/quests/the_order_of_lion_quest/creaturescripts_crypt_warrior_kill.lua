local cryptWarriorKill = CreatureEvent("CryptWarriorKill")

function cryptWarriorKill.onDeath(creature, corpse, lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local kills = player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiKills)
		if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiTask) == 1 and kills < 20 then
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.OnfroiKills, kills + 1)
		end
	end)
	return true
end

cryptWarriorKill:register()
