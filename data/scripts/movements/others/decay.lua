local decay = MoveEvent()

function decay.onStepIn(creature, item, position, fromPosition)
	item:transform(item.itemid + 1)
	item:decay()
	return true
end

decay:type("stepin")
decay:id(293, 461, 3310)
decay:register()
