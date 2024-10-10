local config = {
	teleportId = 1949,
	teleportPosition = Position(33487, 32101, 9),
	destinationPosition = Position(33489, 32088, 9),
	storageKey = Storage.Quest.U10_50.DarkTrails.Mission18,
	getStorageValue = 1,
	setStorageValue = 1,
}

local function removeTeleport(position)
	local teleportItem = Tile(config.teleportPosition):getItemById(config.teleportId)
	if teleportItem then
		teleportItem:remove()
		position:sendMagicEffect(CONST_ME_POFF)
	end
end

local deathPriestShargon = CreatureEvent("DeathPriestShargonDeath")

function deathPriestShargon.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local position = creature:getPosition()
	position:sendMagicEffect(CONST_ME_TELEPORT)
	local item = Game.createItem(config.teleportId, 1, config.teleportPosition)
	if item:isTeleport() then
		item:setDestination(config.destinationPosition)
	end

	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if config.storageKey ~= nil then
			if player:getStorageValue(config.storageKey) < config.getStorageValue then
				player:setStorageValue(config.storageKey, config.setStorageValue)
			end
		end
	end)

	addEvent(removeTeleport, 5 * 60 * 1000, position)
	return true
end

deathPriestShargon:register()
