local closeServer = TalkAction("/closeserver")

function closeServer.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "shutdown" then
		Game.setGameState(GAME_STATE_SHUTDOWN)
		Webhook.sendMessage(":red_circle: Server was shutdown by: **" .. player:getName() .. "**", announcementChannels["serverAnnouncements"])
	elseif param == "save" then
		if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_CLEAN_MAP) then
			cleanMap()
		end
		if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_CLOSE) then
			Game.setGameState(GAME_STATE_CLOSED, true)
		end
		if configManager.getBoolean(configKeys.GLOBAL_SERVER_SAVE_SHUTDOWN) then
			Game.setGameState(GAME_STATE_SHUTDOWN, true)
		end
	elseif param == "maintainance" then
		Game.setGameState(GAME_STATE_MAINTAIN)
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Server is set to maintenance mode.")
	else
		Game.setGameState(GAME_STATE_CLOSED)
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Server is now closed.")
		Webhook.sendMessage(":yellow_square: Server was closed by: **" .. player:getName() .. "**", announcementChannels["serverAnnouncements"])
	end
	return true
end

closeServer:separator(" ")
closeServer:groupType("god")
closeServer:register()
