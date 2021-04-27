local pick = Action()

function pick.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return ActionsLib.usePick(player, item, fromPosition, target, toPosition, isHotkey)
end

pick:id(3456)
pick:register()
