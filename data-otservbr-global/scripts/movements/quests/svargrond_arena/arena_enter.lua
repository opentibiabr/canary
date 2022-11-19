local arenaEnter = MoveEvent()

function arenaEnter.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local pitId = player:getStorageValue(Storage.SvargrondArena.PitDoor)
	if pitId < 1 or pitId > 10 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot enter without Halvar's permission.")
		player:teleportTo(fromPosition, true)
		return true
	end

	local arenaId = player:getStorageValue(Storage.SvargrondArena.Arena)
	if not(PITS[pitId] and ARENA[arenaId]) then
		player:teleportTo(fromPosition, true)
		return true
	end

	local occupant = SvargrondArena.getPitOccupant(pitId, player)
	if occupant then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, occupant:getName() ..
			" is currently in the next arena pit. Please wait until " .. (occupant:getSex() == PLAYERSEX_FEMALE
			and "s" or "") .. "he is done fighting.")
		player:teleportTo(fromPosition, true)
		return true
	end
	SvargrondArena.resetPit(pitId)
	SvargrondArena.scheduleKickPlayer(player.uid, pitId)
	Game.createMonster(ARENA[arenaId].creatures[pitId], PITS[pitId].summon, false, true)

	player:teleportTo(PITS[pitId].center)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:say("FIGHT!", TALKTYPE_MONSTER_SAY)
	return true
end

arenaEnter:type("stepin")
arenaEnter:aid(25100)
arenaEnter:register()
