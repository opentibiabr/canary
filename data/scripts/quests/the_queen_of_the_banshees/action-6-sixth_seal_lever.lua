local sixthSeal = Action()

function sixthSeal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lever = sixthSealTable.uniqueTable[item.uid]
	if not lever then
		return false
	end

	local tile = Tile(lever)
	if tile then
		if item.itemid == 1945 then
			local campfire = tile:getItemById(1423)
			if campfire then
				campfire:transform(1421)
			end
			item:transform(1946)
			return true
		elseif item.itemid == 1946 then
			local campfire = tile:getItemById(1421)
			if campfire then
				campfire:transform(1423)
			end
			item:transform(1945)
			return true
		end
	end
	return false
end

for index, value in pairs(sixthSealTable.uniqueTable) do
	sixthSeal:uid(index)
end

sixthSeal:register()
