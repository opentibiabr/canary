local sixthSeal = Action()

function sixthSeal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lever = sixthSealTable.uniqueTable[item.uid]
	if not lever then
		return false
	end

	local tile = Tile(lever)
	if tile then
		if item.itemid == 2772 then
			local campfire = tile:getItemById(1998)
			if campfire then
				campfire:transform(1996)
			end
			item:transform(2773)
			return true
		elseif item.itemid == 2773 then
			local campfire = tile:getItemById(1996)
			if campfire then
				campfire:transform(1998)
			end
			item:transform(2772)
			return true
		end
	end
	return false
end

for index, value in pairs(sixthSealTable.uniqueTable) do
	sixthSeal:uid(index)
end

sixthSeal:register()
