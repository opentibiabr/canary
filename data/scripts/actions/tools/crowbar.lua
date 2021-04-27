local crowbar = Action()

function crowbar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseCrowbar(player, item, fromPosition, target, toPosition, isHotkey)
end

crowbar:id(2416)
crowbar:register()
