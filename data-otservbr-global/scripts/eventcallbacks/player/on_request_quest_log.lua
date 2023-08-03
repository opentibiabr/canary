local callback = EventCallback()

function callback.playerOnRequestQuestLog(player)
	player:sendQuestLog()
end

callback:register()
