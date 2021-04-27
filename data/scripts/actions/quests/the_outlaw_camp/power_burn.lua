local theOutlawPower = Action()
function theOutlawPower.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local power1 = Tile(Position({x = 32613, y = 32220, z = 10}))
	local barrel = Tile(Position({x = 32614, y = 32209, z = 10}))
	local wall = Tile(Position({x = 32614, y = 32205, z = 10}))
	local stone = Tile(Position({x = 32614, y = 32206, z = 10}))
	local burn = Position({x = 32615, y = 32221, z = 10})

	if item.itemid == 1945 and power1:getItemById(2166) and wall:getItemById(1025) and stone:getItemById(1304) and barrel:getItemById(1774) then
		power1:getItemById(2166):transform(1487)
		wall:getItemById(1025):remove()
		stone:getItemById(1304):transform(1025)
		Game.createItem(1487, 1, burn)
	end
	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

theOutlawPower:id(3402)
theOutlawPower:register()