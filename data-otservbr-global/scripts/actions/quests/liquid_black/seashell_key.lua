local seashellId = 14066

local seashellKey = Action()

function seashellKey.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if target:getId() ~= seashellId then
        return true
    end

    local bookChance = math.random(0, 100)
    if bookChance < 85 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
            'You turn the key in the small lock at the side of the shelf and... the key breaks. Other than that absolutely nothing happens.')
        item:remove(1)
        return true
    end

    local bookColor = math.random(0, 1000)
    if bookColor < 333 then
        player:addItem(14173)
    elseif bookColor >= 667 then
        player:addItem(14174)
    else
        player:addItem(14175)
    end
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
        'A hidden stash appears the very moment you turn the key. Unfortunately the key breaks as you attempt to remove it from the lock.')
    item:remove(1)
    return true
end

seashellKey:id(14009)
seashellKey:register()
