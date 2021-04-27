local dough = MoveEvent()
dough:type("additem")

function dough.onAddItem(moveitem, tileitem, position)
	if moveitem.itemid == 3604 then
		moveitem:transform(3600)
		position:sendMagicEffect(CONST_ME_HITBYFIRE)
	elseif moveitem.itemid == 6276 then
		moveitem:transform(3598, 12)
		position:sendMagicEffect(CONST_ME_HITBYFIRE)
	end
	return true
end

dough:id(2535,2537,2539,2541)
dough:register()
