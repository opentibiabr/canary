local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position({ x = 32780 , y = 32231 , z = 8}))
	if item.itemid == 1945 then
		if tile:getItemById(387) then
			tile:getItemById(387):remove()
			item:transform(1946)
		else
			Game.createItem(387, 1, { x = 32780 , y = 32231 , z = 8})
		end
	else
		Game.createItem(387, 1, { x = 32780 , y = 32231 , z = 8})
		item:transform(1945)
	end
	return true
end

lever:uid(30024)
lever:register()
