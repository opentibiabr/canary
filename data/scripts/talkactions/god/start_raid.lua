local startRaid = TalkAction("/raid")

function startRaid.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	logCommand(player, words, param)
	local returnValue = Game.startRaid(param)
	if returnValue ~= RETURNVALUE_NOERROR then
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, Game.getReturnMessage(returnValue))
	else
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Raid started.")
	end
	return false
end

startRaid:separator(" ")
startRaid:groupType("god")
startRaid:register()
