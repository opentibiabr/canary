local data = {}

local lowerRoshamuulChalk = Action()
function lowerRoshamuulChalk.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local bucket = player:getItemById(2005, true, 0)
    if bucket == nil then
        return fromPosition:sendMagicEffect(3)
    end

    if not data[player:getId()] then
        data[player:getId()] = 0
    end

    data[player:getId()] = data[player:getId()] + 1
    if data[player:getId()] > 10 then
        bucket:transform(22388)
        data[player:getId()] = 0
    end

    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You fill some of the fine chalk into a bucket.")
    item:transform(22470)
    item:decay()
    return true
end

lowerRoshamuulChalk:id(22459)
lowerRoshamuulChalk:register()