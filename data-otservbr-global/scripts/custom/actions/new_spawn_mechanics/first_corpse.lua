local bridgeMechanic = Action()

function bridgeMechanic.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(349401) < 1 then
    player:setStorageValue(349401, 1)
    player:getPosition():sendMagicEffect(244)
    player:say('A brave knight who died in battle against the archangels.', TALKTYPE_MONSTER_SAY)
    else
        return true
    end
end

bridgeMechanic:aid(60840)
bridgeMechanic:register()
