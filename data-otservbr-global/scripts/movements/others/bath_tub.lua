local playerBathTub = 26087

local bathtubEnter = MoveEvent()

function bathtubEnter.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	local condition = Condition(CONDITION_OUTFIT)
	condition:setOutfit({lookTypeEx = playerBathTub})
	condition:setTicks(-1)

	position:sendMagicEffect(CONST_ME_WATERSPLASH)
	item:transform(BATHTUB_FILLED_NOTMOVABLE)
	creature:addCondition(condition)
	return true
end

bathtubEnter:id(BATHTUB_FILLED)
bathtubEnter:register()

local bathtubExit = MoveEvent()
function bathtubExit.onStepOut(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	item:transform(BATHTUB_FILLED)
	creature:removeCondition(CONDITION_OUTFIT)
	return true
end

bathtubExit:id(BATHTUB_FILLED_NOTMOVABLE)
bathtubExit:register()
