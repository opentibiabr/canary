local bearStone = Action()
function bearStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local stonePosition = { x = 32145, y = 32101, z = 11 }

	if item.itemid == 2772 then
		Tile(stonePosition):getItemById(1791):remove()
		item:transform(2773)
	elseif item.itemid == 2773 then
		Position(stonePosition):hasCreature({ x = 32145, y = 32102, z = 11 })
		Game.createItem(1791, 1, stonePosition)
		item:transform(2772)
	end
	return true
end

bearStone:aid(30006)
bearStone:register()
