local shovel = Action()

function shovel.onUse(player, item, itemEx, fromPosition, target, toPosition, isHotkey)
	return onUseShovel(player, item, itemEx, fromPosition, target, toPosition, isHotkey)
end

shovel:id(3457, 5710)
shovel:register()
