local huskyKill = CreatureEvent("HuskyDeath")

function huskyKill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		local value = player:getStorageValue(Storage.TheIceIslands.HuskyKill) or 0
		player:setStorageValue(Storage.TheIceIslands.HuskyKill, value + 1)
	end)
	return true
end

huskyKill:register()
