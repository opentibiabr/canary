local dreamerTicTac = Action()
function dreamerTicTac.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid == 2772 and 2773 or 2772)

	if item.itemid ~= 2772 then
		return true
	end

	local position = Position(32838, 32264, 14)
	Game.createItem(3547, 8, position)
	Game.createItem(3548, 12, { x = 32839, y = 32263, z = 14 })
	return true
end

dreamerTicTac:uid(2272)
dreamerTicTac:register()
