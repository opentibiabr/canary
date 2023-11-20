local position = TalkAction("/pos", "!pos")

function position.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local splitParam = param:split(",")
	if #splitParam == 3 then
		local x, y, z = tonumber(splitParam[1]), tonumber(splitParam[2]), tonumber(splitParam[3])
		if x and y and z then
			player:teleportTo(Position(x, y, z))
		else
			player:sendTextMessage(MESSAGE_STATUS, "Invalid coordinates. Please enter valid x, y, z values.")
		end
	elseif param == "" then
		local playerPosition = player:getPosition()
		player:sendTextMessage(MESSAGE_STATUS, "Your current position is: " .. playerPosition.x .. ", " .. playerPosition.y .. ", " .. playerPosition.z .. ".")
	else
		player:sendTextMessage(MESSAGE_STATUS, "Invalid format. Please enter coordinates as x, y, z.")
	end
	return true
end

position:separator(" ")
position:groupType("gamemaster")
position:register()
