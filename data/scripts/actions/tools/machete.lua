local machete = Action()

function machete.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return ActionsLib.useMachete(player, item, fromPosition, target, toPosition, isHotkey)
	or ActionsLib.destroyItem(player, target, toPosition)
end

machete:id(3308, 3330)
machete:register()
