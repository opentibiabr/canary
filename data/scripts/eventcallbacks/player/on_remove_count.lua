local callback = EventCallback("PlayerOnRemoveCountBaseEvent")

function callback.playerOnRemoveCount(player, item)
	player:sendWaste(item:getId())
end

callback:register()
