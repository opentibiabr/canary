local leverFirstSeal = Action()

function leverFirstSeal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local wall = firstSealTable[item.uid]
	if not wall then
		return false
	end

	if item.uid == 30012 then
		if item.itemid == 27260 then
			Position(wall.position):removeItem(2129)
			Position(wall.position):createItem(369)
			item:transform(2773)
			return true
		elseif item.itemid == 2773 then
			Position(wall.position):removeItem(369)
			Position(wall.position):createItem(2129)
			item:transform(32400)
			return true
		end
		return false
	end

	if item.itemid == 2772 then
		Position(wall.position):removeItem(2129)
		if wall.revert == true then
			addEvent(Position.revertItem, 100 * 1000, wall.position, 2129)
		end
		item:transform(2773)
	elseif item.itemid == 2773 then
		if Position(wall.position):createItem(2129) then
			stopEvent(Position.revertItem)
			item:transform(2772)
			return true
		end
		item:transform(2772)
	end
	return true
end

for index, value in pairs(firstSealTable) do
	leverFirstSeal:uid(index)
end

leverFirstSeal:register()
