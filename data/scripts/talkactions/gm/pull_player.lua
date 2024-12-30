-- Script for set teleport destination
-- /pullPlayer playerName
local pullPlayerToCurrentLocation = TalkAction("/pullplayer", "/pp")

function pullPlayerToCurrentLocation.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	-- Check the first param (player name) exists
	if param == "" then
		player:sendCancelMessage("Player name param required")
		-- Distro log
		logger.error("[pullPlayerToCurrentLocation.onSay] - Player name param not found")
		return true
	end

	local split = param:split(",")
	local name = split[1]

	-- Check if player is online
	local targetPlayer = Player(name)
	if not targetPlayer then
		player:sendCancelMessage("Player " .. string.titleCase(name) .. " is not online.")
		-- Distro log
		logger.error("[pullPlayerToCurrentLocation.onSay] - Player {} is not online", string.titleCase(name))
		return true
	end

	-- Getting current GM/GOD position
	local position = player:getPosition()
	position:getNextPosition(player:getDirection(), 1)

	-- Teleport player to GM/GOD position
	local destination = Position(position.x, position.y, position.z)
	targetPlayer:teleportTo(destination)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player " .. string.titleCase(name) .. "was teleported to the same point that you are.")

end

pullPlayerToCurrentLocation:separator(" ")
pullPlayerToCurrentLocation:groupType("gamemaster")
pullPlayerToCurrentLocation:register()
