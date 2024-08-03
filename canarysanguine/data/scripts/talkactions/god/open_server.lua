local openServer = TalkAction("/openserver")

function openServer.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	Game.setGameState(GAME_STATE_NORMAL)
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Server is now open.")
	Webhook.sendMessage(":green_circle: Server was opened by: **" .. player:getName() .. "**", announcementChannels["serverAnnouncements"])
	return true
end

openServer:separator(" ")
openServer:groupType("god")
openServer:register()
