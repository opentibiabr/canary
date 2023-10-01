
local bridgeMechanic = MoveEvent()



function bridgeMechanic.onStepIn(player, item, fromPosition, target, toPosition, isHotkey)
    player:teleportTo(Position(31683, 31839, 7))
end


bridgeMechanic:aid(60843)
bridgeMechanic:type("stepin")
bridgeMechanic:register()
