local bridgeMechanic = Action()

function bridgeMechanic.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == 650 and target:getId() == 5391 then
        local storageValue = player:getStorageValue(349404)
        if storageValue < 1 then
            player:getPosition():sendMagicEffect(9)
            player:say('Nature flourishes...', TALKTYPE_MONSTER_SAY)
            player:setStorageValue(349404, 1)
            target:transform(5392)
            addEvent(function()
                if target:getId() == 5392 then
                    target:transform(5391)
                    player:setStorageValue(349404, 0)
                end
            end, 30 * 1000)
        end
    end
    return true
end

bridgeMechanic:id(650)
bridgeMechanic:register()
