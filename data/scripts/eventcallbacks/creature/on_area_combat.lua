local callback = EventCallback("CreatureOnAreaCombatBaseEvent")

function callback.creatureOnAreaCombat(creature, tile, isAggressive)
	return RETURNVALUE_NOERROR
end

callback:register()
