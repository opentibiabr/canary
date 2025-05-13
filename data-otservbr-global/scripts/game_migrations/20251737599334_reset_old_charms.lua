local migration = Migration("20251737599334_reset_charms")

function migration:onExecute()
	local totalPlayers = 0

	logger.info("[Migration] Resetting old charms for all players. This may take some time...")
	self:forEachPlayer(function(player)
		player:resetOldCharms()
		totalPlayers = totalPlayers + 1
	end)

	logger.info("[Migration] Successfully reset charms for {} players.", totalPlayers)
end

migration:register()
