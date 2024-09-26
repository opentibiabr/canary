local removeFrags = Action()

function removeFrags.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not isInArray({SKULL_RED, SKULL_BLACK}, player:getSkull()) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only remove RED SKULL or BLACK SKULL!")
        return true
    end
    if(not getTileInfo(player:getPosition()).protection) then
        player:sendCancelMessage("You should be in protection zone.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end
    
    player:setSkull(0)
    player:setSkullTime(0)
    item:remove(1)
    removefrags(player)
    return true
end
removeFrags:id(37338)
removeFrags:register()