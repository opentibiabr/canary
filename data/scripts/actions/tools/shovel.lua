local shovel = Action()

function shovel.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return ActionsLib.useShovel(player, item, fromPosition, target, toPosition, isHotkey)
end

shovel:id(3457, 5710)
shovel:register()
