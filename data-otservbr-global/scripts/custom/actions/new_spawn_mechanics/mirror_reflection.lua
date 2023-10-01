
local bridgeMechanic = Action()

function bridgeMechanic.onUse(player, item, fromPosition, target, toPosition, isHotkey)
   if player:getStorageValue(349402) < 1 then
    player:getPosition():sendMagicEffect(58)
    player:say('The mirror seems to be broken.', TALKTYPE_MONSTER_SAY)
    player:setStorageValue(349402, 1)
   else 
    return true
   end
    
    return true
end

bridgeMechanic:aid(60842)
bridgeMechanic:register()
