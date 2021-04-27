local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- First lever to open the ladder
	if item.uid == 30004 then
		local laddertile = Tile({x = 32225, y = 32276, z = 8})
			if item.itemid == 1945 then
				laddertile:getItemById(9021):transform(8280)
				item:transform(1946)
			else
				laddertile:getItemById(8280):transform(9021)
				item:transform(1945)
			end
	-- Second lever to open the teleport to cyclops
	elseif item.uid == 30005 then
		local entranceTeleportTile = Tile({x = 32232, y = 32276, z = 9})
		local exitTeleportTile = Tile({x = 32225, y = 32276, z = 10})
		if item.itemid == 1945 then
			if entranceTeleportTile:getItemById(1387) and exitTeleportTile:getItemById(1387) then
				entranceTeleportTile:getItemById(1387):remove()
				exitTeleportTile:getItemById(1387):remove()
			else
				local teleportEntrance = Game.createItem(1387, 1, {x = 32232, y = 32276, z = 9})
				local teleportExit = Game.createItem(1387, 1, {x = 32225, y = 32276, z = 10})
				if teleportEntrance and teleportExit then
					teleportEntrance:setDestination({x = 32225, y = 32274, z = 10})
					teleportExit:setDestination({x = 32230, y = 32276, z = 9})
				end
				item:transform(1946)
			end
		elseif item.itemid == 1946 then
			if entranceTeleportTile:getItemById(1387) and exitTeleportTile:getItemById(1387) then
				entranceTeleportTile:getItemById(1387):remove()
				exitTeleportTile:getItemById(1387):remove()
				item:transform(1945)
			end
		end
	end
	return true
end

lever:uid(30004, 30005)
lever:register()
