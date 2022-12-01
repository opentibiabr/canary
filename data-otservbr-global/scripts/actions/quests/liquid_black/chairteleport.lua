local teleportplayer = {x = 33269, y = 31832, z = 1}

local chairteleport = Action()

function chairteleport.onUse(player, item, frompos, item2, topos)

    if player:getStorageValue(Storage.LiquidBlackQuest.Visitor) == 2 then
		player:teleportTo(teleportplayer)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Teleport.")
        player:setStorageValue(Storage.LiquidBlackQuest.Visitor, 3)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Empty.")
    end
	
    return true
end

chairteleport:uid(57744)
chairteleport:register()