 local forja = Action()

function forja.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:openForge()
	return true
end

forja:id(22027)
forja:register()
