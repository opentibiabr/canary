local callback = EventCallback()

function callback.playerOnLookInShop(player, itemType, count)
	return true
end

callback:register()
