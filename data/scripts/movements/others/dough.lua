local pastries = {
	[2693] = 2689,
	[6277] = 6278
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
dough:id(1786, 1788, 1790, 1792)
dough:register()
