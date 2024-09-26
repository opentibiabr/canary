local tools = TalkAction("!tools")

function tools.onSay(player, words, param)	
    if player:removeMoneyBank(1000) then
        player:getPosition():sendMagicEffect(36)
        player:addItem(5710, 1)
		player:addItem(646, 1)	
		player:addItem(3456, 1)
		player:addItem(3308, 1)
		player:addItem(3453, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have bought your tools!")
    else
        player:getPosition():sendMagicEffect(52)
        player:sendCancelMessage("You do not have enough money.")
    end
end
tools:groupType("normal")
tools:register()