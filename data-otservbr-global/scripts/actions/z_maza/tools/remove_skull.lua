local removeSkull = Action()

function removeSkull.onUse(player, item, fromPos, target, toPos, isHotkey)
    local playerPos = player:getPosition()
    local tile = Tile(playerPos)
    if not tile or not tile:hasFlag(TILESTATE_PROTECTIONZONE) then
        player:sendCancelMessage("You can use only in pz.")
        return true
    end

    if player:getSkullTime() == 0 then
        player:sendCancelMessage("You don't have skull time.")
        return true
    end

    player:setSkullTime(0)
    player:setSkull(SKULL_NONE)
    playerPos:sendMagicEffect(CONST_ME_MORTAREA)
    player:say("Remove Skull!")
    item:remove(1)
    return true
end

removeSkull:id(37338)
removeSkull:register()