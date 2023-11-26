local position = TalkAction("/pos", "!pos")

local function extractCoordinates(input)
	local patterns = {
		-- table format
		"{%s*x%s*=%s*(%d+)%s*,%s*y%s*=%s*(%d+)%s*,%s*z%s*=%s*(%d+)%s*}",
		-- Position format
		"Position%s*%((%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*%)",
		-- x, y, z format
		"(%d+)%s*,%s*(%d+)%s*,%s*(%d+)",
	}

	for _, pattern in ipairs(patterns) do
		local x, y, z = string.match(input, pattern)
		if x and y and z then
			return tonumber(x), tonumber(y), tonumber(z)
		end
	end
end

function position.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		local pos = player:getPosition()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your current position is: " .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ".")
		return
	end

	local x, y, z = extractCoordinates(param)
	if x and y and z then
		local teleportPosition = Position(x, y, z)
		local tile = Tile(teleportPosition)
		if not tile then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid tile or position. Send a valid position.")
			return
		end

		player:teleportTo(teleportPosition)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid position format. Use one of the following formats: \n/pos {x = ..., y = ..., z = ...}\n/pos Position(..., ..., ...)\n/pos x, y, z.")
	end
end

position:separator(" ")
position:groupType("gamemaster")
position:register()
