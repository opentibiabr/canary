local magicEffect = TalkAction("/distanceeffect")

function magicEffect.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")

	local effect = tonumber(split[1])
	if effect ~= nil and effect > 0 then
		local playerPos = player:getPosition()
		local direction = player:getDirection()
		local targetPos = Position(playerPos.x, playerPos.y, playerPos.z)

		local distance = 7
		if direction == DIRECTION_NORTH then
			targetPos.y = targetPos.y - distance
		elseif direction == DIRECTION_EAST then
			targetPos.x = targetPos.x + distance
		elseif direction == DIRECTION_SOUTH then
			targetPos.y = targetPos.y + distance
		elseif direction == DIRECTION_WEST then
			targetPos.x = targetPos.x - distance
		end

		player:getPosition():sendDistanceEffect(targetPos, effect, nil, tonumber(split[2]))
	end

	return true
end

magicEffect:separator(" ")
magicEffect:groupType("gamemaster")
magicEffect:register()
