local minotaurTask = CreatureEvent("MinotaurCultTaskDeath")
function minotaurTask.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local storage = player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.JamesfrancisTask)
		if storage >= 0 and storage < 50 then
			player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.Minotaurs.JamesfrancisTask, storage + 1)
		end
	end)
	return true
end

minotaurTask:register()
