
local bridgeMechanic = Action()

function bridgeMechanic.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == 3114 and target:getId() == 5704 then 
        if player:getStorageValue(349403) < 1 then
            player:getPosition():sendMagicEffect(54)
            player:say('The shark seems to calm down.', TALKTYPE_MONSTER_SAY)
            player:setStorageValue(349403, 1)
        else 
            return true
        end
    return true
    end
return true
end

bridgeMechanic:id(3114)
bridgeMechanic:register()
