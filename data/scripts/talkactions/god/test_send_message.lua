local sendMessage = TalkAction("/testmessage")

function sendMessage.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" or param == nil then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Message type is missing, please enter a message type.")
		return
	end

	local split = param:split(",")
	local messageType = tonumber(split[1])
	local textCollor = TEXTCOLOR_WHITE_EXP
	if split[2] then
		textCollor = tonumber(split[2])
	end

	player:sendTextMessage(messageType, "Testing message type.", player:getPosition(), 500, textCollor)
	return true
end

sendMessage:separator(" ")
sendMessage:groupType("god")
sendMessage:register()
