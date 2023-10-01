
local bridgeMechanic = MoveEvent()



function bridgeMechanic.onStepIn(player, item, fromPosition, target, toPosition, isHotkey)
    player:teleportTo(Position(31697, 31856, 5))
end


bridgeMechanic:aid(60844)
bridgeMechanic:type("stepin")
bridgeMechanic:register()
