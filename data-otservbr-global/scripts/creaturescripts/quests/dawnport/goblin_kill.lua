local goblinKill = CreatureEvent("MorrisGoblinDeath")
function goblinKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local killAmount = player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblinCount)
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblin) == 1 and killAmount < 20 then
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisGoblinCount, killAmount + 1)
		end
	end)
	return true
end

goblinKill:register()
