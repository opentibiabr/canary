local ec = EventCallback

function ec.onRequestQuestLine(player, questId)
	player:sendQuestLine(questId)
end

ec:register(--[[0]])
