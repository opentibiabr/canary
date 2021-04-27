local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookType = 267})
condition:setTicks(-1)

local conditions = {
	CONDITION_POISON, CONDITION_FIRE, CONDITION_ENERGY,
	CONDITION_PARALYZE, CONDITION_DRUNK, CONDITION_DROWN,
	CONDITION_FREEZING, CONDITION_DAZZLED, CONDITION_CURSED,
	CONDITION_BLEEDING
}

local swimming = MoveEvent()

function swimming.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end
	for i = 1, #conditions do
		creature:removeCondition(conditions[i])
	end
	creature:addCondition(condition)
	return true
end

swimming:type("stepin")
swimming:id(4620, 4621, 4622, 4623, 4624, 4625)
swimming:register()

swimming = MoveEvent()

function swimming.onStepOut(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	creature:removeCondition(CONDITION_OUTFIT)
	return true
end

swimming:type("stepout")
swimming:id(4620, 4621, 4622, 4623, 4624, 4625)
swimming:register()
