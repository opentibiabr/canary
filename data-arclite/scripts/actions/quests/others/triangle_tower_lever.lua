local othersTriangle = Action()
function othersTriangle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position({x = 32566, y = 32119, z = 7}))
	if item.itemid == 2772 then
		if tile:getItemById(1270) then
			tile:getItemById(1270):remove()
			item:transform(2773)
		else
			Game.createItem(1025, 1, {x = 32566, y = 32119, z = 7})
		end
	else
		Game.createItem(1025, 1, {x = 32566, y = 32119, z = 7})
		item:transform(2772)
	end
	return true
end

othersTriangle:uid(50023)
othersTriangle:register()