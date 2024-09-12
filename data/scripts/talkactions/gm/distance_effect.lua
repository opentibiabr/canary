local magicEffect = TalkAction("/distanceeffect")

function magicEffect.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local effect = tonumber(param)
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

		player:getPosition():sendDistanceEffect(targetPos, effect)
	end

	return true
end

magicEffect:separator(" ")
magicEffect:groupType("gamemaster")
magicEffect:register()
