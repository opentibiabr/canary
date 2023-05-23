local config = {
	[1] =  Position(32991, 31497, 1),
	[2] =  Position(32990, 31498, 1),
	[3] =  Position(32991, 31497, 1),
	[4] =  Position(32992, 31498, 1),
	[5] =  Position(32991, 31497, 1),
	[6] =  Position(32991, 31498, 1),
	[7] =  Position(32990, 31497, 1),
	[8] =  Position(32991, 31496, 1),
	[9] =  Position(32992, 31497, 1),
	[10] = Position(32991, 31496, 1),
	[11] = Position(32991, 31497, 1),
	[12] = Position(32990, 31496, 1),
	[13] = Position(32991, 31497, 1),
	[14] = Position(32992, 31496, 1),
	[15] = Position(32991, 31497, 1),
	[16] = Position(32991, 31496, 1)
}

-- Missing: CONST_ME_CARNIPHILA effects when dancing (pattern unknown)

local mission3DanceDanceEvolution = MoveEvent()

function mission3DanceDanceEvolution.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local dancePosition = config[player:getStorageValue(Storage.UnnaturalSelection.DanceStatus)]
	if not dancePosition then
		return true
	end

	if position ~= dancePosition then
		player:setStorageValue(Storage.UnnaturalSelection.DanceStatus, 1)
		player:say("You did it wrong. now you have to start again.", TALKTYPE_MONSTER_SAY)
		config[1]:sendMagicEffect(CONST_ME_SMALLPLANTS)
		return true
	end

	local danceStatus = player:getStorageValue(Storage.UnnaturalSelection.DanceStatus)
	if danceStatus == 1 then
		player:say("Dance for the mighty Krunus!", TALKTYPE_MONSTER_SAY)
	end

	--Questlog, Unnatural Selection Quest "Mission 2: All Around the World"
	player:setStorageValue(Storage.UnnaturalSelection.DanceStatus,  danceStatus + 1)

	local nextpos = config[player:getStorageValue(Storage.UnnaturalSelection.DanceStatus)]
	if nextpos then
		nextpos:sendMagicEffect(CONST_ME_SMALLPLANTS)
	end

	if danceStatus + 1 > #config then
		--Questlog, Unnatural Selection Quest "Mission 3: Dance Dance Evolution"
		player:setStorageValue(Storage.UnnaturalSelection.Mission03, 3)
		player:setStorageValue(Storage.UnnaturalSelection.Questline, 7)
		player:say("Krunus should be pleased.", TALKTYPE_MONSTER_SAY)
		player:addAchievement("Talented Dancer")
	end
	return true
end

mission3DanceDanceEvolution:type("stepin")
mission3DanceDanceEvolution:aid(12333)
mission3DanceDanceEvolution:register()
