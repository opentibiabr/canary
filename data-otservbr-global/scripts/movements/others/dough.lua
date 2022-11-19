local pastries = {
	[3604] = 3600,
	[6276] = 6277
}

local dough = MoveEvent()

function dough.onAddItem(moveitem, tileitem, position)
	local pastryId = pastries[moveitem.itemid]
	if not pastryId then
		return true
	end

	moveitem:transform(pastryId)
	position:sendMagicEffect(CONST_ME_HITBYFIRE)
	return true
end

dough:type("additem")
dough:id(2535, 2537, 2539, 2541)
dough:register()
