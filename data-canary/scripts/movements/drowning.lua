local condition = Condition(CONDITION_DROWN)
condition:setParameter(CONDITION_PARAM_PERIODICDAMAGE, -20)
condition:setParameter(CONDITION_PARAM_TICKS, -1)
condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 2000)

local drowning = MoveEvent()
drowning:type("stepin")

function drowning.onStepIn(creature, item, position, fromPosition)
	if creature:isPlayer() then
		if math.random(1, 10) == 1 then
			position:sendMagicEffect(CONST_ME_BUBBLES)
		end
		creature:addCondition(condition)
	end
	return true
end

drowning:id(5404, 5405, 5406, 5407, 5408, 5409, 5743, 5764, 8755, 8756, 8757, 9291)
drowning:register()

drowning = MoveEvent()
drowning:type("stepout")

function drowning.onStepOut(creature, item, position, fromPosition)
	if creature:isPlayer() then
		creature:removeCondition(CONDITION_DROWN)
	end
	return true
end

drowning:id(5404, 5405, 5406, 5407, 5408, 5409, 5743, 5764, 8755, 8756, 8757, 9291)
drowning:register()
