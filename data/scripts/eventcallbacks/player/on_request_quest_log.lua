local callback = EventCallback("PlayerOnRequestQuestLogBaseEvent")

function callback.playerOnRequestQuestLog(player)
	player:sendQuestLog()
end

callback:register()
