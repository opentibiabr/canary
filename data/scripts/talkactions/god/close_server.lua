local closeServer = TalkAction("/closeserver")

function closeServer.onSay(player, words, param)
	if param == "shutdown" then
		Game.setGameState(GAME_STATE_SHUTDOWN)
	else
		Game.setGameState(GAME_STATE_CLOSED)
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Server is now closed.")
	end
	return false
end

closeServer:separator(" ")
closeServer:groupType("god")
closeServer:register()
