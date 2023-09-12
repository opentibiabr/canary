local kick = TalkAction("/kick")

function kick.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local target = Player(param)
	if not target then
		player:sendCancelMessage("Player not found.")
		return true
	end

	if target:getGroup():getAccess() then
		player:sendCancelMessage("You cannot kick this player.")
		return true
	end

	Webhook.sendMessage("Player Kicked", target:getName() .. " has been kicked by " .. player:getName(), WEBHOOK_COLOR_WARNING, announcementChannels["serverAnnouncements"])
	target:remove()
	return true
end

kick:separator(" ")
kick:groupType("gamemaster")
kick:register()
