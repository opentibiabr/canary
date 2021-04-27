local roshamuulCaves = {
    Position(33560, 32523, 8),
    Position(33554, 32543, 8),
    Position(33573, 32545, 8),
    Position(33543, 32560, 8),
    Position(33579, 32565, 8),
    Position(33527, 32597, 8)
}

local lowerRoshamuul = MoveEvent()

function lowerRoshamuul.onStepIn(creature, item, position, fromPosition)
    if not creature:isPlayer() then
        return false
    end

    if item:getId() == 22456 then
        creature:teleportTo(Position(33551, 32556, 7))
    else
        creature:teleportTo(roshamuulCaves[math.random(#roshamuulCaves)])
    end
    return true
end

lowerRoshamuul:type("stepin")
lowerRoshamuul:id(22456)
lowerRoshamuul:aid(1500)
lowerRoshamuul:register()
