local lowerRoshamuulTrough = Action()
function lowerRoshamuulTrough.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if (target == nil) or not target:isItem() then
        return false
    end

    if target:getId() == 22550 then
        item:transform(2005, 0)
        toPosition:sendMagicEffect(10)
        player:setStorageValue(ROSHAMUUL_MORTAR_THROWN, math.max(0, player:getStorageValue(ROSHAMUUL_MORTAR_THROWN)) + 1)
    end
    return true
end

lowerRoshamuulTrough:id(22504)
lowerRoshamuulTrough:register()