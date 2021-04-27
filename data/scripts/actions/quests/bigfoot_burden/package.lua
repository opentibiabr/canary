local bigfootPackage = Action()
function bigfootPackage.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid - 1)
	return true
end

bigfootPackage:id(18313)
bigfootPackage:register()