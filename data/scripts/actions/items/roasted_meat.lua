local roastedMeat = Action()

function roastedMeat.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 1998 then -- campfire
		item:transform(22187) -- roasted meat
		toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
	end
	return true
end

roastedMeat:id(22186)
roastedMeat:register()
