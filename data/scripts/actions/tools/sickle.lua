local sickle = Action()

function sickle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return ActionsLib.useSickle(player, item, fromPosition, target, toPosition, isHotkey)
	or ActionsLib.destroyItem(player, target, toPosition)
end

sickle:id(3293, 3306, 32595)
sickle:register()
