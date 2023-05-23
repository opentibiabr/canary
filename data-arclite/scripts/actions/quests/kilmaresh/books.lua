local books = Action()

function books.onUse(player, item, frompos, item2, topos)
    if player:getStorageValue(Storage.Kilmaresh.Second.Investigating) == 4 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You find nothing in the Ambassador's house. If he's in fact a traitor he got rid of any evidence that could incriminate him.")
        player:setStorageValue(Storage.Kilmaresh.Second.Investigating, 5)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Empty.")
    end
    return true
end

books:uid(57504)
books:register()