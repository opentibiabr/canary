local bossEntrance = MoveEvent()

function bossEntrance.onStepIn(creature, item, position, fromPosition, toPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local WarzoneIV = Position(33460, 32267, 15)
	local WarzoneIV_b = Position(33650, 32310, 15)

	local WarzoneV = Position(33324, 32109, 15)
	local WarzoneV_b = Position(33681, 32338, 15)

	local WarzoneVI = Position(33275, 32316, 15)
	local WarzoneVI_b = Position(33717, 32302, 15)

	if item:getPosition() == WarzoneIV then -- Warzone IV
		if player:getStorageValue(Storage.DangerousDepths.Bosses.TheBaronFromBelow) > os.time() then
			player:teleportTo(fromPosition)
			player:say('You have to wait to challenge this enemy again!', TALKTYPE_MONSTER_SAY)
		else
			player:teleportTo(WarzoneIV_b)
		end
	end

	if item:getPosition() == WarzoneV then -- Warzone V
		if player:getStorageValue(Storage.DangerousDepths.Bosses.TheCountOfTheCore) > os.time() then
			player:teleportTo(fromPosition)
			player:say('You have to wait to challenge this enemy again!', TALKTYPE_MONSTER_SAY)
		else
			player:teleportTo(WarzoneV_b)
		end
	end

	if item:getPosition() == WarzoneVI then -- Warzone VI
		if player:getStorageValue(Storage.DangerousDepths.Bosses.TheDukeOfTheDepths) > os.time() then
			player:teleportTo(fromPosition)
			player:say('You have to wait to challenge this enemy again!', TALKTYPE_MONSTER_SAY)
		else
			player:teleportTo(WarzoneVI_b)
		end
	end
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

bossEntrance:type("stepin")
bossEntrance:aid(57243)
bossEntrance:register()
