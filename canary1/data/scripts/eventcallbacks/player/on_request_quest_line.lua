local callback = EventCallback()

function callback.playerOnRequestQuestLine(player, questId)
	player:sendQuestLine(questId)
end

callback:register()
