local broadcast = TalkAction("/b")

function broadcast.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local text = player:getName() .. " broadcasted: " .. param
	logger.info(text)
	Webhook.sendMessage("Broadcast", text, WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
	for _, targetPlayer in ipairs(Game.getPlayers()) do
		targetPlayer:sendPrivateMessage(player, param, TALKTYPE_BROADCAST)
	end
	return true
end

broadcast:separator(" ")
broadcast:groupType("gamemaster")
broadcast:register()
