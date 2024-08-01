local lever1 = Action()

function lever1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = { x = 32792, y = 31581, z = 7 }
	if item.itemid == 2772 then
		Tile(position):getItemById(1282):remove()
		item:transform(2773)
	elseif item.itemid == 2773 then
		Game.createItem(1282, 1, position)
		item:transform(2772)
	end
	return true
end

lever1:uid(30006)
lever1:register()

local lever2 = Action()

function lever2.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = { x = 32790, y = 31594, z = 7 }
	if item.itemid == 2772 then
		Tile(position):getItemById(1772):remove()
		item:transform(2773)
	elseif item.itemid == 2773 then
		Game.createItem(1772, 1, position)
		item:transform(2772)
	end
	return true
end

lever2:uid(30035)
lever2:register()
