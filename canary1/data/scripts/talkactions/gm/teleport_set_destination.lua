-- Script for set teleport destination
-- /teleport xxxx, xxxx, x
local teleportSetDestination = TalkAction("/teleport", "/tp")

function teleportSetDestination.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local params = param:split(",")
	if params[3] then
		local position = player:getPosition()
		position:getNextPosition(player:getDirection(), 1)
		local destination = Position(params[1], params[2], params[3])
		if destination and destination:getTile() then
			local tp = Game.createItem(35502, 1, position)
			if tp then
				tp:setDestination(destination)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("New position: %s", param))
			end
		else
			player:sendCancelMessage("Destination position is not valid.")
		end
	else
		player:sendCancelMessage('You need to declare the X, Y of Z of destination. Please use "/teleport X, Y, Z".')
	end
	return true
end

teleportSetDestination:separator(" ")
teleportSetDestination:groupType("gamemaster")
teleportSetDestination:register()
