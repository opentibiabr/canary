local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = { x = 32780 , y = 32231 , z = 8}
	local tile = Tile(Position(position))
	if item.itemid == 2772 then
		if tile:getItemById(389) then
			tile:getItemById(389):remove()
			item:transform(2773)
		else
			Game.createItem(387, 1, position)
		end
	else
		Game.createItem(387, 1, position)
		item:transform(2772)
	end
	return true
end

lever:uid(30024)
lever:register()
