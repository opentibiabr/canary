local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local teleportPosition = {x = 33316, y = 31574, z = 15}
	local stonePosition = {x = 33314, y = 31575, z = 15}

	if item.itemid == 2772 then
		local teleport = Game.createItem(1949, 1, teleportPosition)
		if teleport then
			teleport:setDestination({x = 33328, y = 31592, z = 14})
			Position(teleportPosition):sendMagicEffect(CONST_ME_TELEPORT)
		end

		Tile(stonePosition):getItemById(1842):remove()
		item:transform(2773)
	elseif item.itemid == 2773 then
		Position(stonePosition):hasCreature({x = 33315, y = 31575, z = 15})
		Tile(teleportPosition):getItemById(1949):remove()
		Position(teleportPosition):sendMagicEffect(CONST_ME_POFF)
		Game.createItem(1842, 1, stonePosition)
		item:transform(2772)
	end
	return true
end

lever:uid(30007)
lever:register()
