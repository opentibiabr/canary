local coruja = Action()

function coruja.onUse(player, item, frompos, item2, topos)
    if player:getStorageValue(Storage.Kilmaresh.Nine.Owl) == 1 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You discover an owl resting in a tree. Thats special, because you have never seen an owl in all of Kilmaresh.")
        player:setStorageValue(Storage.Kilmaresh.Nine.Owl, 2)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Sorry")
    end
    return true
end

coruja:uid(57525)
coruja:register()