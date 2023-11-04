local bosses = {
	["the count of the core"] = { storage = Storage.DangerousDepths.Bosses.TheCountOfTheCore, value = os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN), teleportPosition = Position(33681, 32340, 15), toPosition = Position(33682, 32315, 15), toPositionBack = Position(33324, 32111, 15) },
	["the duke of the depths"] = { storage = Storage.DangerousDepths.Bosses.TheDukeOfTheDepths, value = os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN), teleportPosition = Position(33719, 32302, 15), toPosition = Position(33691, 32301, 15), toPositionBack = Position(33275, 32318, 15) },
	["the baron from below"] = { storage = Storage.DangerousDepths.Bosses.TheBaronFromBelow, value = os.time() + configManager.getNumber(configKeys.BOSS_DEFAULT_TIME_TO_FIGHT_AGAIN), teleportPosition = Position(33650, 32312, 15), toPosition = Position(33668, 32301, 15), toPositionBack = Position(33462, 32267, 15) },
}

local function revert(position, toPosition)
	local teleport = Tile(position):getItemById(22761)
	if teleport then
		teleport:transform(1949)
		teleport:setDestination(toPosition)
	end
end

local bossesMissionDepth = CreatureEvent("DepthWarzoneBossDeath")
function bossesMissionDepth.onDeath(creature)
	local boss = bosses[player:getName():lower()]
	if not boss then
		return true
	end
	onDeathForDamagingPlayers(creature, function(player, _value)
		if player:getStorageValue(boss.storage) < boss.value then
			player:setStorageValue(boss.storage, boss.value)
		end
	end)

	local teleport = Tile(boss.teleportPosition):getItemById(1949)
	if teleport then
		teleport:transform(22761)
		teleport:setDestination(boss.toPosition)
		addEvent(revert, 20 * 60 * 1000, boss.teleportPosition, boss.toPositionBack)
	end
	return true
end

bossesMissionDepth:register()
