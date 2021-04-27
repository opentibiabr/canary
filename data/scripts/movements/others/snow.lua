local snow = MoveEvent()

function snow.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if player and player:isInGhostMode() then
		return true
	end

	if item.itemid == 670 then
		item:transform(6594)
	else
		item:transform(item.itemid + 15)
	end
	item:decay()
	return true
end

snow:type("stepout")
snow:id(670, 6580, 6581, 6582, 6583, 6584, 6585, 6586, 6587, 6588, 6589, 6590, 6591, 6592, 6593)
snow:register()
