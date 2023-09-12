local teleportToCreature = TalkAction("/listplayers")

function teleportToCreature.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local onlyActive = param == "active" and true or false

	local players = Game.getPlayers()
	local playerList = {}

	for _, targetPlayer in ipairs(players) do
		if targetPlayer:getName() == player:getName() then
			goto continue
		end

		if not onlyActive then
			table.insert(playerList, targetPlayer)
		else
			local isGhost = targetPlayer:isInGhostMode()
			local isTraining = onExerciseTraining[targetPlayer:getId()]
			local isIdle = targetPlayer:getIdleTime() >= 5 * 60 * 1000
			local isActive = not isGhost and not isTraining and not isIdle
			if isActive then
				table.insert(playerList, targetPlayer)
			end
		end
		::continue::
	end

	if #playerList == 0 then
		player:sendCancelMessage("There are no active players.")
		return false
	end

	local window = ModalWindow({
		title = "Teleport to Player",
		message = "select player to teleport",
	})
	for _, targetPlayer in pairs(playerList) do
		if targetPlayer then
			window:addChoice(targetPlayer:getName(), function(player, button, choice)
				if button.name ~= "Select" then
					return true
				end
				player:teleportTo(targetPlayer:getPosition())
			end)
		end
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)

	return true
end

teleportToCreature:separator(" ")
teleportToCreature:groupType("gamemaster")
teleportToCreature:register()
