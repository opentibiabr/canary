local deathEvent = CreatureEvent("SvargrondArenaBossDeath")
function deathEvent.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local player = Player(mostDamageKiller)
	if not player then
		return true
	end

	local pit = player:getStorageValue(Storage.SvargrondArena.PitDoor)
	if pit < 1 or pit > 10 then
		return
	end

	local arena = player:getStorageValue(Storage.SvargrondArena.Arena)
	if arena < 1 then
		return
	end

	if not table.contains(ARENA[arena].creatures, creature:getName():lower()) then
		return
	end

	-- Remove pillar and create teleport
	local pillarTile = Tile(PITS[pit].pillar)
	if pillarTile then
		local pillarItem = pillarTile:getItemById(SvargrondArena.itemPillar)
		if pillarItem then
			pillarItem:remove()

			local teleportItem = Game.createItem(SvargrondArena.itemTeleport, 1, PITS[pit].tp)
			if teleportItem then
				teleportItem:setActionId(25200)
			end

			SvargrondArena.sendPillarEffect(pit)
		end
	end
	player:setStorageValue(Storage.SvargrondArena.PitDoor, pit + 1)
	player:say("Victory! Head through the new teleporter into the next room.", TALKTYPE_MONSTER_SAY)
	return true
end

deathEvent:register()

local serverstartup = GlobalEvent("SvargrondArenaBossDeathStartup")
function serverstartup.onStartup()
	for _, arena in pairs(ARENA) do
		for _, bossName in pairs(arena.creatures) do
			local mType = MonsterType(bossName)
			if not mType then
				logger.error("[SvargrondArenaBossDeathStartup] boss with name {} is not a valid MonsterType", bossName)
			else
				mType:registerEvent("SvargrondArenaBossDeath")
			end
		end
	end
end
serverstartup:register()
