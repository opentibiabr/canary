local bathtubEnter = MoveEvent()

function bathtubEnter.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local condition = Condition(CONDITION_OUTFIT)
	condition:setOutfit({ lookTypeEx = 26087 })
	condition:setTicks(-1)

	position:sendMagicEffect(CONST_ME_WATERSPLASH)
	item:transform(BATHTUB_FILLED_NOTMOVABLE)
	player:addCondition(condition)
	return true
end

bathtubEnter:type("stepin")
bathtubEnter:id(BATHTUB_FILLED)
bathtubEnter:register()

local bathtubExit = MoveEvent()

function bathtubExit.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	item:transform(BATHTUB_FILLED)
	player:removeCondition(CONDITION_OUTFIT)
	return true
end

bathtubExit:type("stepout")
bathtubExit:id(BATHTUB_FILLED_NOTMOVABLE)
bathtubExit:register()
