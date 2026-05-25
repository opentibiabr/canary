local market = Action()
function market.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not configManager.getBoolean(configKeys.ENABLE_MARKET) then
		player:sendCancelMessage("Market is disabled.")
		return true
	end
	player:openMarket()
	return true
end
market:id(12903)
market:register()
