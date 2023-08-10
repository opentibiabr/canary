local openServer = TalkAction("/openserver")

function openServer.onSay(player, words, param)
	Game.setGameState(GAME_STATE_NORMAL)
	player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Server is now open.")
	return false
end

openServer:separator(" ")
openServer:groupType("god")
openServer:register()
