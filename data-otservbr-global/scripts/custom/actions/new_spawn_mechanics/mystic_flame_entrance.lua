
local bridgeMechanic = MoveEvent()



function bridgeMechanic.onStepIn(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(349405) < 1 then
    player:teleportTo(Position(31646, 31843, 6))
    else
    player:teleportTo(Position(31676, 31925, 7))
    end
end


bridgeMechanic:aid(60846)
bridgeMechanic:type("stepin")
bridgeMechanic:register()
