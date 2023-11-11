local minotaurTask = CreatureEvent("MinotaurCultTaskDeath")
function minotaurTask.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local storage = player:getStorageValue(Storage.CultsOfTibia.Minotaurs.JamesfrancisTask)
		if storage >= 0 and storage < 50 then
			player:setStorageValue(Storage.CultsOfTibia.Minotaurs.JamesfrancisTask, storage + 1)
		end
	end)
	return true
end

minotaurTask:register()
