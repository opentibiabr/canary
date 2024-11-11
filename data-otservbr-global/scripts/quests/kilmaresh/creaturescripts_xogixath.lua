local xogixath = CreatureEvent("XogixathDeath")

function xogixath.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.Kilmaresh.Twelve.Xogixath) == 1 then
			player:setStorageValue(Storage.Kilmaresh.Twelve.Xogixath, 2)
		end
	end)
	return true
end

xogixath:register()
