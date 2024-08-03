local renegadeOrcKill = CreatureEvent("RenegadeOrcDeath")
function renegadeOrcKill.onDeath(creature, _corpse, _lastHitKiller, player, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if player:getStorageValue(Storage.Quest.U8_54.AnUneasyAlliance.QuestDoor) == 0 then
			player:setStorageValue(Storage.Quest.U8_54.AnUneasyAlliance.QuestDoor, 1)
		end
	end)
	return true
end

renegadeOrcKill:register()
