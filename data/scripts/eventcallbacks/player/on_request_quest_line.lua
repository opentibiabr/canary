local callback = EventCallback("PlayerOnRequestQuestLineBaseEvent")

function callback.playerOnRequestQuestLine(player, questId)
	player:sendQuestLine(questId)
end

callback:register()
