local fps = TalkAction("!fps")

function fps.onSay(player, words, param)
    if player:hasExhaustion("fps-cooldown") then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to wait 10 seconds before using it again.")
        return false
    end

    player:setExhaustion("fps-cooldown", 10)
	player:dropConnection()
	return true
end

fps:groupType("normal")
fps:register()
