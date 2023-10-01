
local bridgeMechanic = MoveEvent()



function bridgeMechanic.onStepIn(player, item, fromPosition, target, toPosition, isHotkey)
    player:teleportTo(Position(31676, 31925, 7))
    player:setStorageValue(349405, 1)
    player:say('Entering on Vengeance Grounds.', TALKTYPE_MONSTER_SAY)
end


bridgeMechanic:aid(60845)
bridgeMechanic:type("stepin")
bridgeMechanic:register()
