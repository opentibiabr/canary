local ec = EventCallback

function ec.onRequestQuestLog(player)
	player:sendQuestLog()
end

ec:register(--[[0]])
