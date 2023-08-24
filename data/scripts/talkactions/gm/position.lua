local position = TalkAction("/pos", "!pos")

function position.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local param = string.gsub(param, "%s+", "")
	local tile = load("return " .. param)()
	local split = param:split(",")
	if type(tile) == "table" and tile.x and tile.y and tile.z then
		player:teleportTo(Position(tile.x, tile.y, tile.z))
	elseif split and param ~= "" then
		player:teleportTo(Position(split[1], split[2], split[3]))
	elseif param == "" then
		local playerPosition = player:getPosition()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your current position is: \z
		" .. playerPosition.x .. ", " .. playerPosition.y .. ", " .. playerPosition.z .. ".")
	end
	return true
end

position:separator(" ")
position:groupType("gamemaster")
position:register()
