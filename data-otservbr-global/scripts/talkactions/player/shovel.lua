local shovel = TalkAction("!shovel")

function shovel.onSay(player, words, param)
    if player:removeMoneyBank(20) then
        player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
        player:addItem(3457, 1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have bought a shovel!")
    else
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        player:sendCancelMessage("You do not have enough money.")
    end
end

shovel:register()