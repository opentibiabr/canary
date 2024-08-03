local broadcast = TalkAction("/b")

function Broadcast(text, filter)
	for _, targetPlayer in ipairs(Game.getPlayers()) do
		if filter and not filter(targetPlayer) then
			goto continue
		end
		targetPlayer:sendTextMessage(MESSAGE_ADMINISTRATOR, text)
		::continue::
	end
end

function broadcast.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local text = player:getName() .. " broadcasted: " .. param
	logger.info(text)
	Broadcast(param)
	return true
end

broadcast:separator(" ")
broadcast:groupType("gamemaster")
broadcast:register()
