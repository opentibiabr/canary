local teleportToCreature = TalkAction("/active")

function teleportToCreature.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local players = Game.getPlayers()
	local activePlayers = {}

	for _, targetPlayer in ipairs(players) do
		local isGhost = targetPlayer:isInGhostMode()
		local isTraining = _G.OnExerciseTraining[targetPlayer:getId()]
		local isIdle = targetPlayer:getIdleTime() >= 5 * 60 * 1000
		local isActive = not isGhost and not isTraining and not isIdle
		if isActive then
			table.insert(activePlayers, targetPlayer)
		end
	end

	if #activePlayers == 0 then
		player:sendCancelMessage("There are no active players.")
		return true
	end

	local targetPlayer = activePlayers[math.random(#activePlayers)]
	player:teleportTo(targetPlayer:getPosition())
	return true
end

teleportToCreature:separator(" ")
teleportToCreature:groupType("gamemaster")
teleportToCreature:register()
