local promotion = TalkAction("!promotion")

function promotion.onSay(player, words, param)
    local promotion = player:getVocation():getPromotion()
    if player:getStorageValue(STORAGEVALUE_PROMOTION) == 1 then
        player:sendCancelMessage("You are already promoted!")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    elseif player:getLevel() < 20 then
        player:sendCancelMessage("I am sorry, but I can only promote you once you have reached level 20.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    elseif not player:removeMoneyBank(20000) then
        player:sendCancelMessage("You do not have enough money.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You receive a promotion!")
        player:setVocation(promotion)
        player:setStorageValue(STORAGEVALUE_PROMOTION, 0)
        player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
    end
end
promotion:groupType("normal")
promotion:register()