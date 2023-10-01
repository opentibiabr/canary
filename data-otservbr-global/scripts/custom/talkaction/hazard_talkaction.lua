local hazardLevel = TalkAction("!hazard")

function hazardLevel.onSay(player, words, param)
    local storageHazard = player:getStorageValue(112550)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your Hazard Level is " .. storageHazard ..".")

end
hazardLevel:separator(" ")
hazardLevel:register()