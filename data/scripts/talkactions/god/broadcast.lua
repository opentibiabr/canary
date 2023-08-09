local broadcast = TalkAction("/b")

function broadcast.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	Spdlog.info("" .. player:getName() .. " broadcasted: ".. param)
	for _, targetPlayer in ipairs(Game.getPlayers()) do
		targetPlayer:sendPrivateMessage(player, param, TALKTYPE_BROADCAST)
	end
	return false
end

broadcast:separator(" ")
broadcast:groupType("god")
broadcast:register()
