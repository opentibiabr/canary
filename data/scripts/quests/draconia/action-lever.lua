local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = {x = 32790, y = 31594, z = 7}
	if item.itemid == 1945 then
		Tile(position):getItemById(1285):remove()
		item:transform(1946)
	elseif item.itemid == 1946 then
		Game.createItem(1285, 1, position)
		item:transform(1945)
	end
	return true
end

lever:uid(30006)
lever:register()
