vipStand = Action()
local delayInSeconds = 180

function vipStand.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local currentTime, lastUseTime = os.time(), player:getStorageValue(1002)
    local isPlayerVip = player:isVip()

    local delay = isPlayerVip and 60 or delayInSeconds

    if not lastUseTime or currentTime - lastUseTime >= delay then
        player:teleportTo({x = 1229, y = 921, z = 7})
        toPosition:sendMagicEffect(CONST_ME_TELEPORT)
        player:setStorageValue(1002, currentTime)
        return true
    else
        local timeRemaining = delay - (currentTime - lastUseTime)
        local minutes, seconds = math.floor(timeRemaining / 60), math.floor(timeRemaining % 60)
        local message = string.format("You need to wait %02d:%02d to use security standard again.", minutes, seconds)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
        return false
    end
end

vipStand:aid(9999)
vipStand:register()