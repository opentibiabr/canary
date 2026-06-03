local seeds = MoveEvent()

function seeds.onAddItem(moveitem, tileitem, position, creature)
	if tileitem.itemid == 306 then
		if moveitem.itemid == 647 then
			tileitem:transform(324)
			tileitem:decay()
			moveitem:remove(1)
			position:sendMagicEffect(CONST_ME_POFF)
		elseif moveitem.itemid == 13844 then
			tileitem:transform(14031)
			tileitem:decay()
			moveitem:remove(1)
			position:sendMagicEffect(CONST_ME_POFF)
		end
	end
	return true
end

seeds:id(306)
seeds:register()
