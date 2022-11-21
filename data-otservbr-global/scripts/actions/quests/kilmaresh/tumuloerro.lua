local tumuloerro = Action()

function tumuloerro.onUse(player, item, frompos, item2, topos)

    if player:getStorageValue(Storage.Kilmaresh.Thirteen.Presente) == 1 then

		-- player:setStorageValue(Storage.Kilmaresh.Treze.Presente, 2)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"The grave is empty. Nothing than gaping void.")
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Empty.")
    end
	
    return true
end

tumuloerro:uid(57544)
tumuloerro:register()