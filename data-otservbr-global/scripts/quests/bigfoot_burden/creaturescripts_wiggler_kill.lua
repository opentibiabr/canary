local wigglerKill = CreatureEvent("WigglerDeath")
function wigglerKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local value = player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.ExterminatedCount)
		if value < 10 and player:getStorageValue(Storage.Quest.U9_60.BigfootsBurden.MissionExterminators) == 1 then
			player:setStorageValue(Storage.Quest.U9_60.BigfootsBurden.ExterminatedCount, value + 1)
		end
	end)
	return true
end

wigglerKill:register()
