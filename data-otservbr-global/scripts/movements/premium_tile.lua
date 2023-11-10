local checkPremium = MoveEvent()
function checkPremium.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return true
    end
    -- Check requirements
    if not player:isPremium() then
        player:say("Aprenas jogadores premium, podem passar por aqui.", TALKTYPE_MONSTER_SAY, false, player, fromPosition)
        player:teleportTo(fromPosition)
        fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
        return true
    end
    return true
end
checkPremium:position({x = 32339, y = 32231, z = 6}) -- essa será a posição que você vai colocar uma uniqueId no RME.
checkPremium:register()