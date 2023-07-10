local nightmarePosition = Position(33542, 32421, 15)

local nightmareVortex = MoveEvent()

function nightmareVortex.onStepIn(creature, item, position, fromPosition)
    local player = creature:getPlayer()
    if not player then
        return false
    end

    player:teleportTo(nightmarePosition)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been trapped in a nightmare.")

    return true
end

nightmareVortex:type("stepin")
nightmareVortex:aid(33542)
nightmareVortex:register()