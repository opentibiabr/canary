local spoon = Action()

function spoon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey)
end

spoon:id(2565)
spoon:register()
