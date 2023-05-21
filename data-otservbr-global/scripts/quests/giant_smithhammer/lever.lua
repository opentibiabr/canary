local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = { x = 32780 , y = 32231 , z = 8}
	local tile = Tile(Position(position))

	if item.itemid == 2772 and tile:getItemById(389) then
		tile:getItemById(389):remove()
		item:transform(2773)
	elseif item.itemid == 2773 and not tile:getItemById(389) then
		Game.createItem(389, 1, position)
		item:transform(2772)
	end
	return true
end

lever:uid(30024)
lever:register()
