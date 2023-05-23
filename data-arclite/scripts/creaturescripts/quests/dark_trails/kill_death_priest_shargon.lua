local config = {
	teleportId = 1949,
	teleportPosition = {x = 33487, y = 32101, z = 9},
	destinationPosition = Position(33489, 32088, 9),
	storageKey = Storage.DarkTrails.Mission18,
	getStorageValue = 1,
	setStorageValue = 2
}

local function removeTeleport(position)
	local teleportItem = Tile(config.teleportPosition):getItemById(config.teleportId)
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
	local item = Game.createItem(config.teleportId, 1, config.teleportPosition)
	if item:isTeleport() then
		item:setDestination(config.destinationPosition)
	end
	if config.storageKey ~= nil then
		if creature:getStorageValue(config.storageKey) < config.getStorageValue then
			creature:setStorageValue(config.storageKey, config.setStorageValue)
		end
	end
	addEvent(removeTeleport, 5 * 60 * 1000, position)
	return true
end

deathPriestShargon:register()
