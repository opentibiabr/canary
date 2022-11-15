local tutorPosition = TalkAction("!position")

function tutorPosition.onSay(player, words, param)

	if player:getAccountType() == ACCOUNT_TYPE_NORMAL then
		return true
	end

	local position = player:getPosition()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your current position is: \z
		" .. position.x .. ", " .. position.y .. ", " .. position.z .. ".")
	return false
end

tutorPosition:register()
