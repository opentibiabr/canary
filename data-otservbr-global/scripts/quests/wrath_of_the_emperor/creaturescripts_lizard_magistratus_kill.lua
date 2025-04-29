local lizardMagistratusKill = CreatureEvent("LizardMagistratusDeath")
function lizardMagistratusKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local storage = player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission06)
		if storage >= 0 and storage < 5 then
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission06, math.max(1, storage) + 1)
		end
	end)
	return true
end

lizardMagistratusKill:register()
