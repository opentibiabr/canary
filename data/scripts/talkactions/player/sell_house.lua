local sellHouse = TalkAction("!sellhouse")

function sellHouse.onSay(player, words, param)
	local tradePartner = Player(param)
	if not tradePartner or tradePartner == player then
		player:sendCancelMessage("Trade player not found.")
		return true
	end

	local house = player:getTile():getHouse()
	if not house then
		player:sendCancelMessage("You must stand in your house to initiate the trade.")
		return true
	end

	local returnValue = house:startTrade(player, tradePartner)
	if returnValue ~= RETURNVALUE_NOERROR then
		player:sendCancelMessage(returnValue)
	end
	return true
end

if not configManager.getBoolean(configKeys.CYCLOPEDIA_HOUSE_AUCTION) then
	sellHouse:separator(" ")
	sellHouse:groupType("normal")
	sellHouse:register()
end
