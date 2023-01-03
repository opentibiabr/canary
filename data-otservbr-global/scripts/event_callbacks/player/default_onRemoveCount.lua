local ec = EventCallback

function ec.onRemoveCount(player, item)
	player:sendWaste(item:getId())
end

ec:register(--[[0]])
