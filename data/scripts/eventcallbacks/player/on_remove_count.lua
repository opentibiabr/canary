local callback = EventCallback()

function callback.playerOnRemoveCount(player, item)
	player:sendWaste(item:getId())
end

callback:register()
