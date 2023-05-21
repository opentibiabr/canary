local position = TalkAction("/pos", "!pos")

function position.onSay(player, words, param)

	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	local param = string.gsub(param, "%s+", "")
	local position = player:getPosition()
	local tile = load("return "..param)()
	local split = param:split(",")
	if type(tile) == "table" and tile.x and tile.y and tile.z then
		player:teleportTo(Position(tile.x, tile.y, tile.z))
	elseif split and param ~= "" then
		player:teleportTo(Position(split[1], split[2], split[3]))
	elseif param == "" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your current position is: \z
		" .. position.x .. ", " .. position.y .. ", " .. position.z .. ".")
	end
	return false
end

position:separator(" ")
position:register()
