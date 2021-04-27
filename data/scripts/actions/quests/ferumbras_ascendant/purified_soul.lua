local ferumbrasAscendantPurifiedSoul = Action()
function ferumbrasAscendantPurifiedSoul.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local devourer = target:getName():lower() == 'sin devourer' and target:isMonster()
	if not devourer then
		return false
	end

	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	target:say('The Sin Devourer has been driven out!', TALKTYPE_MONSTER_SAY)
	target:remove()
	item:remove()
	return true
end

ferumbrasAscendantPurifiedSoul:id(25354)
ferumbrasAscendantPurifiedSoul:register()