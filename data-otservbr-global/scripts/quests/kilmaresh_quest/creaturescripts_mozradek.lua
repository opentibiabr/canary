local mozradek = CreatureEvent("MozradekDeath")

function mozradek.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Mozradek) == 1 then
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Mozradek, 2)
		end
	end)
	return true
end

mozradek:register()
