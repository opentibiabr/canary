local lyre = Action()

function lyre.onUse(player, item, frompos, item2, topos)

    if player:getStorageValue(Storage.Kilmaresh.Thirteen.Lyre) == 2 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"You have found Lyre.")
		player:addItem(36282, 1)
        player:setStorageValue(Storage.Kilmaresh.Thirteen.Lyre, 3)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The bag can not be opened.")
    end
	
    return true
end

lyre:uid(57529)
lyre:register()