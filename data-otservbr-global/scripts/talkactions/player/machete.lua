local machete = TalkAction("!machete")

function machete.onSay(player, words, param)
    if player:removeMoneyBank(35) then
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        player:addItem(3308, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have bought a machete!")
    else
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendCancelMessage("You do not have enough money.")
    end
end

machete:register()