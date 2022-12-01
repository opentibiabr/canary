local entrance = MoveEvent()

function entrance.onStepIn(creature, item, toPosition, fromPosition)
    return Entrance_onStepIn(creature, item, toPosition, fromPosition)
end

entrance:type("stepin")
entrance:aid(47710)
entrance:register()
