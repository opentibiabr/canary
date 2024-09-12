local callback = EventCallback("PlayerOnTradeAcceptBaseEvent")

function callback.playerOnTradeAccept(player, target, item, targetItem)
	player:closeForge()
	target:closeForge()
	player:closeImbuementWindow()
	target:closeImbuementWindow()
	return true
end

callback:register()
