local buckets = {
    [22387] = 22388,
    [22388] = 22387
}

local lowerRoshamuulMixtune = Action()
function lowerRoshamuulMixtune.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if (target == nil) or not target:isItem() then
        return false
    end

    if target:getId() == buckets[item:getId()] then
        item:transform(2005, 0)
        target:transform(22503)
    end
    return true
end

lowerRoshamuulMixtune:id(22387,22388)
lowerRoshamuulMixtune:register()