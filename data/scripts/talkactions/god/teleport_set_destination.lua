-- Script for set teleport destination
-- /teleport xxxx, xxxx, x
local teleportSetDestination = TalkAction("/teleport")

function teleportSetDestination.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Teleport position required.")
		return false
	end

	local position = player:getPosition()
	position:getNextPosition(player:getDirection(), 1)
	local split = param:split(",")
	local teleportId = 1949
	local teleport = Tile(position):getItemById(teleportId)
	if teleport and teleport:isTeleport() then
		if split then
			teleport:setDestination(Position(split[1], split[2], split[3]))
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("New position: %s, %s, %s", split[1], split[2], split[3]))
		end
	else
		player:sendCancelMessage("Not is item of id ".. teleportId ..".")
		return true
	end
	return false
end

teleportSetDestination:separator(" ")
teleportSetDestination:register()
