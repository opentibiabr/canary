local position = TalkAction("/pos", "!pos")

function position.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		local pos = player:getPosition()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your current position is: " .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ".")
		return
	end

	local teleportPosition = param:toPosition()
	if not teleportPosition then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid position format. Use one of the following formats: \n/pos {x = ..., y = ..., z = ...}\n/pos Position(..., ..., ...)\n/pos x, y, z.")
		return
	end

	local tile = Tile(teleportPosition)
	if not tile then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid tile or position. Send a valid position.")
		return
	end

	player:teleportTo(teleportPosition)
	if not player:isInGhostMode() then
		teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
end

position:separator(" ")
position:groupType("gamemaster")
position:register()
