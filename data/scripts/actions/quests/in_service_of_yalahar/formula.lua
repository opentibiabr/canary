local inServiceYalaharFormula = Action()
function inServiceYalaharFormula.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not isInArray({1786, 1787, 1788, 1789, 1790, 1791, 1792, 1793, 9911}, target.itemid) then
		return false
	end

	item:remove(1)
	toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:say("You burned the alchemist formula.", TALKTYPE_MONSTER_SAY)
	return true
end

inServiceYalaharFormula:id(9733)
inServiceYalaharFormula:register()