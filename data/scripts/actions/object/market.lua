local market = Action()

function market.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:openMarket()
	return true
end

market:id(14405)
market:register()
