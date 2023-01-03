local ec = EventCallback

function ec.onTradeAccept(player, target, item, targetItem)
	player:closeForge()
	target:closeForge()
	player:closeImbuementWindow()
	target:closeImbuementWindow()
	return true
end

ec:register(--[[0]])
