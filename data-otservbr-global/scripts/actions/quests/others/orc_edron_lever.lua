local othersOrcEdron = Action()
function othersOrcEdron.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position(33171, 31897, 8))
	if item.itemid == 2772 then
		local stoneItem = tile:getItemById(1772)
		if stoneItem then
			stoneItem:remove()
			item:transform(2773)
		end
	else
		tile:relocateTo(Position(33171, 31898, 8), true)
		Game.createItem(1772, 1, Position(33171, 31897, 8))
		item:transform(2772)
	end
	return true
end

othersOrcEdron:uid(1017)
othersOrcEdron:register()