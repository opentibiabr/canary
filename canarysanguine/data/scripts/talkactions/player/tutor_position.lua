local tutorPosition = TalkAction("!position")

function tutorPosition.onSay(player, words, param)
	local position = player:getPosition()
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your current position is: \z
		" .. position.x .. ", " .. position.y .. ", " .. position.z .. ".")
	return true
end

tutorPosition:groupType("senior tutor")
tutorPosition:register()
