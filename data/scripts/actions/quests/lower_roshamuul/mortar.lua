local lowerRoshamuulMortar = Action()
function lowerRoshamuulMortar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if (target == nil) or not target:isItem() then
        return false
    end

    if (target:getId() == 2005) and (target:getFluidType() == 1) then
        item:transform(2005, 0)
        target:transform(22504)
    end
    return true
end

lowerRoshamuulMortar:id(22503)
lowerRoshamuulMortar:register()