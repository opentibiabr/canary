local exitPosition = Position(32605, 31902, 4)

local trapDoor = Action()

function trapDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local ground = Tile(exitPosition):getGround()
	if ground and isInArray({369, 413}, ground.itemid) then
		ground:transform(ground.itemid == 369 and 413 or 369)

		if ground.itemid == 369 then
			local items = ground:getTile():getItems()
			if items then
				exitPosition.z = exitPosition.z + 1
				for i = 1, #items do
					items[i]:moveTo(exitPosition)
				end
			end
		end
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

trapDoor:aid(50238)
trapDoor:register()
