local scissors = Action()

function scissors.onUse(player, item, frompos, item2, topos)

    if player:getStorageValue(Storage.Kilmaresh.Set.Ritual) == 1 then
		player:addItem(36162, 1)
		player:setStorageValue(Storage.Kilmaresh.Set.Ritual, 2)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have found a  ritual scissors.")
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Empty.")
    end
	
	
    return true
end

scissors:uid(uniqueid)
scissors:register()