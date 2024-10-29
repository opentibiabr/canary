local crusher = Action()

function crusher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseCrusher(player, item, fromPosition, target, toPosition, isHotkey)
end

crusher:id(46627, 46628)
crusher:register()
