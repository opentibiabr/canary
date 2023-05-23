local theOutlawPower = Action()
function theOutlawPower.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local power1 = Tile(Position({x = 32613, y = 32220, z = 10}))
	local barrel = Tile(Position({x = 32614, y = 32209, z = 10}))
	local wall = Tile(Position({x = 32614, y = 32205, z = 10}))
	local stone = Tile(Position({x = 32614, y = 32206, z = 10}))
	local burn = Position({x = 32615, y = 32221, z = 10})

	if item.itemid == 2772 and power1:getItemById(3050) and wall:getItemById(1270) and stone:getItemById(1791) and barrel:getItemById(2523) then
		power1:getItemById(3050):transform(2118)
		wall:getItemById(1270):remove()
		stone:getItemById(1791):transform(1270)
		Game.createItem(2118, 1, burn)
	end
	item:transform(item.itemid == 2772 and 2773 or 2772)
	return true
end

theOutlawPower:id(1491)
theOutlawPower:register()