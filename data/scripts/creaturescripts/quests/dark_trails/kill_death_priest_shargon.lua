local function removeTeleport(position)
	local teleportItem = Tile({x = 33487, y = 32101, z = 9}):getItemById(1387)
	if teleportItem then
		teleportItem:remove()
		position:sendMagicEffect(CONST_ME_POFF)
	end
end

local deathPriestShargon = CreatureEvent("ShargonKill")
function deathPriestShargon.onKill(creature, target)
	if target:isPlayer() or target:getMaster() or target:getName():lower() ~= "death priest shargon" then
		return true
	end

	local position = target:getPosition()
	position:sendMagicEffect(CONST_ME_TELEPORT)
	local item = Game.createItem(1387, 1, {x = 33487, y = 32101, z = 9})
	if item:isTeleport() then
		item:setDestination(Position(33489,32088,9))
	end
	if creature:getStorageValue(Storage.DarkTrails.Mission18) < 1 then
		creature:setStorageValue(Storage.DarkTrails.Mission18, 1)
	end
	addEvent(removeTeleport, 5 * 60 * 1000, position)
	return true
end

deathPriestShargon:register()
