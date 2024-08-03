local skipTiles = TalkAction("/a")

function skipTiles.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local steps = tonumber(param)
	if not steps then
		return true
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection(), steps)

	position = player:getClosestFreePosition(position, false)
	if position.x == 0 then
		player:sendCancelMessage("You cannot teleport there.")
		return true
	end

	player:teleportTo(position)
	return true
end

skipTiles:separator(" ")
skipTiles:groupType("gamemaster")
skipTiles:register()
