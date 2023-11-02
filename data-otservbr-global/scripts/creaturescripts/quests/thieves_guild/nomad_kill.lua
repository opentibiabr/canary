local nomadKill = CreatureEvent("NomadDeath")
function nomadKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if player:getStorageValue(Storage.ThievesGuild.Mission04) == 3 then
			player:setStorageValue(Storage.ThievesGuild.Mission04, 4)
		end
	end)
	return true
end

nomadKill:register()
