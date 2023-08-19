local closeServer = TalkAction("/closeserver")

function closeServer.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "shutdown" then
		Game.setGameState(GAME_STATE_SHUTDOWN)
		Webhook.sendMessage("Server Shutdown", "Server was shutdown by: " .. player:getName(),
			WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
	else
		Game.setGameState(GAME_STATE_CLOSED)
		player:sendTextMessage(MESSAGE_ADMINISTRADOR, "Server is now closed.")
		Webhook.sendMessage("Server Closed", "Server was closed by: " .. player:getName(),
			WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
	end
	return true
end

closeServer:separator(" ")
closeServer:groupType("god")
closeServer:register()
