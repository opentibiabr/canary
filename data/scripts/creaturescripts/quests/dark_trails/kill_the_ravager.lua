local function removeTeleport(position)
	local teleportItem = Tile({x = 33496, y = 32070, z = 8}):getItemById(1387)
	if teleportItem then
		teleportItem:remove()
		position:sendMagicEffect(CONST_ME_POFF)
	end
end

local theRavager = CreatureEvent("TheRavager")
function theRavager.onKill(creature, target)
	if target:isPlayer() or target:getMaster() or target:getName():lower() ~= "the ravager" then
		return true
	end

	local position = target:getPosition()
	position:sendMagicEffect(CONST_ME_TELEPORT)
	local item = Game.createItem(1387, 1, {x = 33496, y = 32070, z = 8})
	if item:isTeleport() then
		item:setDestination(Position(33459,32083,8))
	end
	if creature:getStorageValue(Storage.DarkTrails.Mission11) < 1 then
		creature:setStorageValue(Storage.DarkTrails.Mission11, 1)
	end
	addEvent(removeTeleport, 5 * 60 * 1000, position)
	return true
end

theRavager:register()
