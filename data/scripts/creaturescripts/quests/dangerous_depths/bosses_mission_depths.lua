local function revert(position, toPosition)
	local teleport = Tile(position):getItemById(25417)
	if teleport then
		teleport:transform(1387)
		teleport:setDestination(toPosition)
	end
end

local bossesMissionDepth = CreatureEvent("BossesMissionDepth")
function bossesMissionDepth.onKill(creature, creature)
	if not creature or not creature:isPlayer() then
		return true
	end

	if not target or not target:isMonster() then
		return true
	end

	local bosses = {
		["the count of the core"] = {stg = Storage.DangerousDepths.Bosses.TheCountOfTheCore, value = os.time() + 20*60*60, teleportPosition = Position(33681, 32340, 15),
		toPosition = Position(33682, 32315, 15), toPositionBack = Position(33324, 32111, 15)},
		["the duke of the depths"] = {stg = Storage.DangerousDepths.Bosses.TheDukeOfTheDepths, value = os.time() + 20*60*60, teleportPosition = Position(33719, 32302, 15),
		toPosition = Position(33691, 32301, 15), toPositionBack = Position(33275, 32318, 15)},
		["the baron from below"] = {stg = Storage.DangerousDepths.Bosses.TheBaronFromBelow, value = os.time() + 20*60*60, teleportPosition = Position(33650, 32312, 15),
		toPosition = Position(33668, 32301, 15), toPositionBack = Position(33462, 32267, 15)},
	}

	local boss = bosses[creature:getName():lower()]
	if boss then
		for playerid, damage in pairs(creature:getDamageMap()) do
			local player = Player(playerid)
			if player then
				if player:getStorageValue(boss.stg) < boss.value then
					player:setStorageValue(boss.stg, boss.value)
				end
			end
		end
		local teleport = Tile(boss.teleportPosition):getItemById(1387)
		if teleport then
			teleport:transform(25417)
			teleport:setDestination(boss.toPosition)
			addEvent(revert, 20*60*1000, boss.teleportPosition, boss.toPositionBack)
		end
	end
	return true
end

bossesMissionDepth:register()
