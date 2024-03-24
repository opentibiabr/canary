local condition = Condition(CONDITION_DROWN)
condition:setParameter(CONDITION_PARAM_PERIODICDAMAGE, -20)
condition:setParameter(CONDITION_PARAM_TICKS, -1)
condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 2000)

local conditionHaste = Condition(CONDITION_HASTE)
conditionHaste:setTicks(-1)
conditionHaste:setFormula(1.0, 300, 1.0, 300)

local drowning = MoveEvent()
drowning:type("stepin")

function drowning.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local headItem = player:getSlotItem(CONST_SLOT_HEAD)
	if headItem and table.contains({ 5460, 11585, 13995 }, headItem:getId()) then
		if player:hasExhaustion("coconut-shrimp-bake") then
			player:addCondition(conditionHaste)
		end

		return true
	elseif math.random(1, 10) == 1 then
		position:sendMagicEffect(CONST_ME_BUBBLES)
	end

	player:addCondition(condition)
	return true
end

drowning:id(5404, 5405, 5406, 5407, 5408, 5409, 5743, 5764, 8755, 8756, 8757, 9291)
drowning:register()

drowning = MoveEvent()
drowning:type("stepout")

function drowning.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:removeCondition(CONDITION_DROWN)
	player:removeCondition(CONDITION_HASTE)
	return true
end

drowning:id(5404, 5405, 5406, 5407, 5408, 5409, 5743, 5764, 8755, 8756, 8757, 9291)
drowning:register()
