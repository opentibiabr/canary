local killDragon = CreatureEvent("TheFirstDragonDragonTaskDeath")

function killDragon.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local storage = player:getStorageValue(Storage.FirstDragon.DragonCounter)
		if storage >= 0 and storage < 200 then
			player:setStorageValue(Storage.FirstDragon.DragonCounter, player:getStorageValue(Storage.FirstDragon.DragonCounter) + 1)
		end
	end)
	return true
end

killDragon:register()
