local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({ lookType = 267 })
condition:setTicks(-1)

local conditions = {
	CONDITION_POISON,
	CONDITION_FIRE,
	CONDITION_ENERGY,
	CONDITION_PARALYZE,
	CONDITION_DRUNK,
	CONDITION_DROWN,
	CONDITION_FREEZING,
	CONDITION_DAZZLED,
	CONDITION_CURSED,
	CONDITION_BLEEDING,
}

local swimming = MoveEvent()

function swimming.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	for i = 1, #conditions do
		player:removeCondition(conditions[i])
	end

	player:addCondition(condition)
	return true
end

swimming:type("stepin")
swimming:id(unpack(swimmingTiles))
swimming:register()

swimming = MoveEvent()

function swimming.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:removeCondition(CONDITION_OUTFIT)
	return true
end

swimming:type("stepout")
swimming:id(unpack(swimmingTiles))
swimming:register()
