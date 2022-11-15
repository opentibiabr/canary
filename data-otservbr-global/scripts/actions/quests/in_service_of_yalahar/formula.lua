local inServiceYalaharFormula = Action()
function inServiceYalaharFormula.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isInArray({2535, 2536, 2537, 2538, 2539, 2540, 2541, 2542, 8997}, target.itemid) then
		return false
	end
	player:setStorageValue(Storage.InServiceofYalahar.GoodSide, 0)
	item:remove(1)
	toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:say("You burned the alchemist formula.", TALKTYPE_MONSTER_SAY)
	return true
end

inServiceYalaharFormula:id(8818)
inServiceYalaharFormula:register()