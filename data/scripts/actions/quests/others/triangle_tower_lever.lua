local othersTriangle = Action()
function othersTriangle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position({x = 32566, y = 32119, z = 7}))
	if item.itemid == 1945 then
		if tile:getItemById(1025) then
			tile:getItemById(1025):remove()
			item:transform(1946)
		else
			Game.createItem(1025, 1, {x = 32566, y = 32119, z = 7})
		end
	else
		Game.createItem(1025, 1, {x = 32566, y = 32119, z = 7})
		item:transform(1945)
	end
	return true
end

othersTriangle:uid(50023)
othersTriangle:register()