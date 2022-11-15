local blacktp = Action()

function blacktp.onUse(player, item, frompos, item2, topos)

    if player:getStorageValue(Storage.TheSecretLibrary.HighDry) == 5 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"Welcome to the Secret Library.")
		player:teleportTo(Position(32516, 32537, 12))
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "sorry")
    end
	
    return true
end

blacktp:uid(26705)
blacktp:register()