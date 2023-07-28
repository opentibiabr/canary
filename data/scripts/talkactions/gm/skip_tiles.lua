local skipTiles = TalkAction("/a")

function skipTiles.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local steps = tonumber(param)
	if not steps then
		return false
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection(), steps)

	position = player:getClosestFreePosition(position, false)
	if position.x == 0 then
		player:sendCancelMessage("You cannot teleport there.")
		return false
	end

	player:teleportTo(position)
	return false
end

skipTiles:separator(" ")
skipTiles:groupType("gamemaster")
skipTiles:register()
