local mozradek = CreatureEvent("MozradekDeath")

function mozradek.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.Kilmaresh.Twelve.Mozradek) == 1 then
			player:setStorageValue(Storage.Kilmaresh.Twelve.Mozradek, 2)
		end
	end)
	return true
end

mozradek:register()
