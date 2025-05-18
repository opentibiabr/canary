local trollKill = CreatureEvent("MorrisTrollDeath")
function trollKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local killAmount = player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisTrollCount)
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorriskTroll) == 1 and killAmount < 20 then
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisTrollCount, killAmount + 1)
		end
	end)
	return true
end

trollKill:register()
