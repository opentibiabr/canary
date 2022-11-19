local blueberryBush = Action()

function blueberryBush.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(3700)
	item:decay()
	Game.createItem(3588, 3, fromPosition)
	return true
end

blueberryBush:id(3699)
blueberryBush:register()
