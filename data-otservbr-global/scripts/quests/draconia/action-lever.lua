local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = {x = 32790, y = 31594, z = 7}
	if item.itemid == 2772 then
		Tile(position):getItemById(1772):remove()
		item:transform(2773)
	elseif item.itemid == 2773 then
		Game.createItem(1772, 1, position)
		item:transform(2772)
	end
	return true
end

lever:uid(30006)
lever:register()
