local checkPremium = MoveEvent()
function checkPremium.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end
    -- Check requirements
    if not player:isPremium() then
        player:say("Only Premium players are able to enter this portal.", TALKTYPE_MONSTER_SAY, true, player, fromPosition)
        player:teleportTo(fromPosition)
        fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end
    return true
end
checkPremium:uid(50241)
checkPremium:register()