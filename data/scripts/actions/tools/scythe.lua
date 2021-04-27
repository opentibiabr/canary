local scythe = Action()

function scythe.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseScythe(player, item, fromPosition, target, toPosition, isHotkey)
end

scythe:id(2550)
scythe:register()
