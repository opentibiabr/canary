local callback = EventCallback()

function callback.playerOnBrowseField(player, position)
	return true
end

callback:register()
