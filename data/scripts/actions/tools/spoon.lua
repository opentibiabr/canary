local spoon = Action()

function spoon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return ActionsLib.useSpoon(player, item, fromPosition, target, toPosition, isHotkey)
end

spoon:id(3468, 20189)
spoon:register()
