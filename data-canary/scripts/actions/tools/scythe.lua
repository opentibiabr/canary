local scythe = Action()

function scythe.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return ActionsLib.useScythe(player, item, fromPosition, target, toPosition, isHotkey)
end

scythe:id(3453)
scythe:register()
