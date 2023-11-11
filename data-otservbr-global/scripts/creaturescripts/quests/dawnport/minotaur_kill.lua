local minotaurKill = CreatureEvent("MorrisMinotaurDeath")
function minotaurKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local killAmount = player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinosCount)
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinos) == 1 and killAmount < 20 then
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.MorrisMinosCount, killAmount + 1)
		end
	end)
	return true
end

minotaurKill:register()
