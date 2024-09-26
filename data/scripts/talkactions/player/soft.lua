local softBoots = TalkAction("!softboots")

function softBoots.onSay(player, words, param)

    if player:getItemCount(6530) >= 1 then
        if player:removeMoney(20000) then
            if not player:removeItem(6530, 1) then
                player:sendCancelMessage("You don't have a worn soft boots to repair.")
                player:getPosition():sendMagicEffect(CONST_ME_POFF)
            end
            player:addItem(6529, 1)
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Your worn soft boots has been repaired!")
            player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        else
            player:sendCancelMessage("You don't have 20000 gold coints to repair a worn soft boots.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
        end
    else
        player:sendCancelMessage("You don't have a worn soft boots to repair.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
    end

    return false
end
softBoots:groupType("normal")
softBoots:register()