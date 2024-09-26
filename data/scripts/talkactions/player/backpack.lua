local backpack = TalkAction("!backpack")

function backpack.onSay(player, words, param)	
    if player:removeMoneyBank(5000) then	
        player:getPosition():sendMagicEffect(52)
        player:addItem(30320, 1)    
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have bought a random backpack")
    else
        player:getPosition():sendMagicEffect(36)
        player:sendCancelMessage("You do not have enough money.")
    end
end

backpack:groupType("normal")
backpack:register()



