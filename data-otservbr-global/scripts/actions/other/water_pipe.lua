local waterPipe = Action()

function waterPipe.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:getPosition():sendMagicEffect(CONST_ME_POFF)
	return true
end

waterPipe:id(2974,2980,21323)
waterPipe:register()
