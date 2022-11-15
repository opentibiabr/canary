local lowerRoshamuulTrough = Action()
function lowerRoshamuulTrough.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if (target == nil) or not target:isItem() then
        return false
    end

    if target:getId() == 20216 then
        item:transform(2873, 0)
        toPosition:sendMagicEffect(10)
        player:setStorageValue(ROSHAMUUL_MORTAR_THROWN, math.max(0, player:getStorageValue(ROSHAMUUL_MORTAR_THROWN)) + 1)
    end
    return true
end

lowerRoshamuulTrough:id(20170)
lowerRoshamuulTrough:register()