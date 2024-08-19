local bragrumol = CreatureEvent("BragrumolDeath")

function bragrumol.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.Kilmaresh.Twelve.Bragrumol) == 1 then
			player:setStorageValue(Storage.Kilmaresh.Twelve.Bragrumol, 2)
		end
	end)
	return true
end

bragrumol:register()
