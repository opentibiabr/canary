local setting = {
	[293] = 294,
	[475] = 476,
	[1066] = 1067
}

local decayTo = MoveEvent()
decayTo:type("stepin")

function decayTo.onStepIn(creature, item, position, fromPosition)
	item:transform(setting[item.itemid])
	return true
end

for index, value in pairs(setting) do
	decayTo:id(index)
end

decayTo:register()
