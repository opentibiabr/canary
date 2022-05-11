local sickle = Action()

function sickle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return onUseSickle(player, item, fromPosition, target, toPosition, isHotkey)
end

sickle:id(3293, 3306, 32595)
sickle:register()
