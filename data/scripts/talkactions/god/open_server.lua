local openServer = TalkAction("/openserver")

function openServer.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	Game.setGameState(GAME_STATE_NORMAL)
	player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Server is now open.")
	Webhook.sendMessage("Server Open", "Server was opened by: " .. player:getName(), WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
	return true
end

openServer:separator(" ")
openServer:groupType("god")
openServer:register()
