local xogixath = CreatureEvent("XogixathDeath")

function xogixath.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Xogixath) == 1 then
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Twelve.Xogixath, 2)
		end
	end)
	return true
end

xogixath:register()
