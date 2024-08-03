local spoon = Action()

function spoon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseSpoon(player, item, fromPosition, target, toPosition, isHotkey)
end

spoon:id(3468)
spoon:register()
