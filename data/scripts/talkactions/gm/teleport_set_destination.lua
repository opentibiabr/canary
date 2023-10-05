-- Script for set teleport destination
-- /teleport xxxx, xxxx, x
local teleportSetDestination = TalkAction("/teleport")

function teleportSetDestination.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Teleport position required.")
		return true
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection(), 1)
	local tile = Tile(position)
	local teleport = tile and tile:getItemByType(ITEM_TYPE_TELEPORT)
	if teleport then
		local split = param:split(",") -- Split always return a table, even if it's empty
		if #split ~= 3 then
			player:sendCancelMessage('You need to declare the X, Y of Z of destination. Please use "/teleport X, Y, Z".')
			return true
		else
			local destPosition = Position(split[1], split[2], split[3])
			if destPosition and destPosition:getTile() then
				teleport:setDestination(destPosition)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("New position: %s", param))
			else
				player:sendCancelMessage("Destination position is not valid.")
				return true
			end
		end
	else
		player:sendCancelMessage("The item is not a teleport type")
		return true
	end
	return true
end

teleportSetDestination:separator(" ")
teleportSetDestination:groupType("gamemaster")
teleportSetDestination:register()
