local callback = EventCallback()

function callback.creatureOnAreaCombat(creature, tile, isAggressive)
	return true
end

callback:register()
