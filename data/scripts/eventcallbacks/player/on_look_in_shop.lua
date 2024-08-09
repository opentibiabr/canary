local callback = EventCallback("PlayerOnLookInShopBaseEvent")

function callback.playerOnLookInShop(player, itemType, count)
	return true
end

callback:register()
