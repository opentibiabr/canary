local bragrumol = CreatureEvent("BragrumolDeath")

function bragrumol.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Bragrumol) == 1 then
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Bragrumol, 2)
		end
	end)
	return true
end

bragrumol:register()
