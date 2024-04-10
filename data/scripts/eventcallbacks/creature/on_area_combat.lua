local callback = EventCallback("CreatureOnAreaCombatBaseEvent")

function callback.creatureOnAreaCombat(creature, tile, isAggressive)
	return true
end

callback:register()
