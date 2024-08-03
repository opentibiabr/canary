local lizardMagistratusKill = CreatureEvent("LizardMagistratusDeath")
function lizardMagistratusKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local storage = player:getStorageValue(Storage.WrathoftheEmperor.Mission06)
		if storage >= 0 and storage < 4 then
			player:setStorageValue(Storage.WrathoftheEmperor.Mission06, math.max(1, storage) + 1)
		end
	end)
	return true
end

lizardMagistratusKill:register()
