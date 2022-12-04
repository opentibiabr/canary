local trap = Action()

function trap.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(3481)
	fromPosition:sendMagicEffect(CONST_ME_POFF)
	return true
end

trap:id(3482)
trap:register()
