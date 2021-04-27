local machete = Action()

function machete.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseMachete(player, item, fromPosition, target, toPosition, isHotkey)
end

machete:id(2420)
machete:register()
