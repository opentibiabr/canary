local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookType = 267})
condition:setTicks(-1)

local swimming = MoveEvent()
swimming:type("stepin")

function swimming.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	creature:addCondition(condition)
	return true
end

swimming:id(629, 630, 631, 632, 633, 634, 4809, 4810, 4811, 4812, 4813, 4814)
swimming:register()

local swimming = MoveEvent()
swimming:type("stepout")

function swimming.onStepOut(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	creature:removeCondition(CONDITION_OUTFIT)
	return true
end

swimming:id(629, 630, 631, 632, 633, 634, 4809, 4810, 4811, 4812, 4813, 4814)
swimming:register()
