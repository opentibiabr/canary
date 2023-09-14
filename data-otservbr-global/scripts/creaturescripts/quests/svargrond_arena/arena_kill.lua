local svargrondArenaKill = CreatureEvent("SvargrondArenaKill")
function svargrondArenaKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return
	end

	local player = creature:getPlayer()
	local pit = player:getStorageValue(Storage.SvargrondArena.PitDoor)
	if pit < 1 or pit > 10 then
		return
	end

	local arena = player:getStorageValue(Storage.SvargrondArena.Arena)
	if arena < 1 then
		return
	end

	if not isInArray(ARENA[arena].creatures, targetMonster:getName():lower()) then
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
	player:say('Victory! Head through the new teleporter into the next room.', TALKTYPE_MONSTER_SAY)
	return true
end

svargrondArenaKill:register()
