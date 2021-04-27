local crowbar = Action()

function crowbar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return ActionsLib.useCrowbar(player, item, fromPosition, target, toPosition, isHotkey)
	or ActionsLib.destroyItem(player, target, toPosition)
end

crowbar:id(3304)
crowbar:register()
