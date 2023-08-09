local teleportToTown = TalkAction("/town")

function teleportToTown.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local town = Town(param) or Town(tonumber(param))
	if town then
		player:teleportTo(town:getTemplePosition())
	else
		player:sendCancelMessage("Town not found.")
	end
	return false
end

teleportToTown:separator(" ")
teleportToTown:groupType("gamemaster")
teleportToTown:register()
