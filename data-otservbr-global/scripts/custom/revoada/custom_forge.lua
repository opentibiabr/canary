local customForge = Action()

function customForge.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:openForge()
	return true
end

customForge:id(ITEM_GODNESS_FORGE)
customForge:register()
