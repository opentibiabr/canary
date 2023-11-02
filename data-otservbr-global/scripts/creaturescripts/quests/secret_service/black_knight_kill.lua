local blackKnightKill = CreatureEvent("BlackKnightDeath")
function blackKnightKill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.SecretService.AVINMission04) == 1 then
			player:setStorageValue(Storage.SecretService.AVINMission04, 2)
		end
	end)
	return true
end

blackKnightKill:register()
