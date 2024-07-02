local callback = EventCallback("PlayerOnBrowseFieldBaseEvent")

function callback.playerOnBrowseField(player, position)
	return true
end

callback:register()
