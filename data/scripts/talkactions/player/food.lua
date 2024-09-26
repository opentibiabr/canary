local aol = TalkAction("!food")

function aol.onSay(player, words, param)
	local totalCost = 1000 + (configManager.getNumber(configKeys.BUY_AOL_COMMAND_FEE) or 0)
	if player:removeMoneyBank(totalCost) then
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:addItem(3725, 100)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have bought 100 brown mushroom for %i gold!", totalCost))
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage(string.format("You do not have enough money. You need %i gold to buy food", totalCost))
	end
	return true
end

aol:groupType("normal")
aol:register()
