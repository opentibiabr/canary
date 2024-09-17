local forge = Action()

function forge.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:openForge()
	return true
end

forge:id(37122, 37128, 37129, 37131, 37132, 37133, 37153, 37157)
forge:register()
