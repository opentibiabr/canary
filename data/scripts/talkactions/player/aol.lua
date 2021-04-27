local aol = TalkAction("!aol")

function aol.onSay(player, words, param)	
    if player:removeMoneyNpc(50000) then
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        player:addItem(2173, 1)    
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have bought an amulet of loss for 50K!")
    else
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendCancelMessage("You do not have enough money.")
    end
end

aol:register()
