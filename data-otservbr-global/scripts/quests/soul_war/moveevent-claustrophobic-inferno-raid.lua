local firstRaid = MoveEvent()
local secondRaid = MoveEvent()
local thirdRaid = MoveEvent()

local spawnMonsterName = "Brachiodemon"

-- Registering encounters, stages and move events
for raidNumber, raid in ipairs(SoulWarQuest.claustrophobicInfernoRaids) do
	-- Registering encounter
	local raidName = string.format("Claustrophobic Inferno Raid %d", raidNumber)
	local encounter = Encounter(raidName, {
		zone = raid.getZone(),
		timeToSpawnMonsters = "3s",
	})

	local spawnTimes = SoulWarQuest.claustrophobicInfernoRaids.suriviveTime / SoulWarQuest.claustrophobicInfernoRaids.spawnTime

	-- Registering encounter stages
	for i = 1, spawnTimes do
		encounter
			:addSpawnMonsters({
				{
					name = spawnMonsterName,
					positions = raid.spawns,
				},
			})
			:autoAdvance(SoulWarQuest.claustrophobicInfernoRaids.spawnTime * 1000)
	end

	function encounter:onReset(position)
		encounter:removeMonsters()
		addEvent(function(zone)
			zone:refresh()
			zone:removePlayers()
		end, SoulWarQuest.claustrophobicInfernoRaids.timeToKick * 1000, raid.getZone())
		logger.debug("{} has ended", raidName)
	end

	encounter:register()

	-- Registering move event
	local raidMoveEvent = MoveEvent()

	function raidMoveEvent.onStepIn(creature, item, position, fromPosition)
		if not creature:getPlayer() then
			return true
		end
		if fromPosition.y == position.y - (raidNumber % 2 ~= 0 and -1 or 1) then -- if player comes from the raid zone don't start the raid
			return
		end
		logger.debug("{} has started", raidName)
		encounter:start()
		return true
	end

	for _, pos in pairs(raid.sandTimerPositions) do
		raidMoveEvent:position(pos)
	end

	raidMoveEvent:register()
end
