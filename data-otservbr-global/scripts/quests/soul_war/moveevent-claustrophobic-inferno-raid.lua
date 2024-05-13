local firstRaid = MoveEvent()
local secondRaid = MoveEvent()
local thirdRaid = MoveEvent()

local spawnMonsterName = "Brachiodemon"

local firstRaidNumber = 1
local secondRaidNumber = 2
local thirdRaidNumber = 3

local function createTeleportEffect(position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

local function spawnMonsters(raidNumber)
	if not SoulWarQuest.raids[raidNumber].timerStarted then
		return
	end
	for _, spawnPosition in pairs(SoulWarQuest.raids[raidNumber].spawns) do
		addEvent(createTeleportEffect, 1000, spawnPosition)
		addEvent(createTeleportEffect, 2000, spawnPosition)
		addEvent(createTeleportEffect, 3000, spawnPosition)
		addEvent(Game.createMonster, 4000, spawnMonsterName, spawnPosition, true, true)
	end
	SoulWarQuest.raids[raidNumber].spawnEvent = addEvent(spawnMonsters, SoulWarQuest.raids.spawnTime * 1000, raidNumber)
end

local function kickPlayers(zone, raidNumber)
	SoulWarQuest.raids[raidNumber].toggleTimer()
	for _, player in pairs(zone:getPlayers()) do
		player:teleportTo(SoulWarQuest.raids[raidNumber].exitPosition)
	end
end

local function endRaid(zone, raidNumber)
	if SoulWarQuest.raids[raidNumber].spawnEvent then
		stopEvent(SoulWarQuest.raids[raidNumber].spawnEvent)
	end
	for _, monster in pairs(zone:getMonsters()) do
		if not monster:getMaster() then
			monster:getPosition():sendMagicEffect(CONST_ME_POFF)
			monster:remove()
		end
	end
	SoulWarQuest.raids[raidNumber].kickEvent = addEvent(kickPlayers, SoulWarQuest.raids.timeToKick * 1000, zone, raidNumber)
	logger.debug("Claustrophobic Inferno Raid #{} ended", raidNumber)
end

local function raid(zone, raidNumber, position, fromPosition)
	if fromPosition.y == position.y - (raidNumber % 2 ~= 0 and -1 or 1) then -- if player comes from the raid zone don't start the raid
		return
	end
	if SoulWarQuest.raids[raidNumber].timerStarted then
		return
	end
	logger.warn("Claustrophobic Inferno Raid #{} started", raidNumber)
	SoulWarQuest.raids[raidNumber].toggleTimer()
	SoulWarQuest.raids[raidNumber].spawnEvent = addEvent(spawnMonsters, SoulWarQuest.raids.spawnTime * 1000, raidNumber)
	SoulWarQuest.raids[raidNumber].endEvent = addEvent(endRaid, SoulWarQuest.raids.suriviveTime * 1000, zone, raidNumber)
end

function firstRaid.onStepIn(creature, item, position, fromPosition)
	if not creature:getPlayer() then
		return true
	end
	raid(SoulWarQuest.raids[firstRaidNumber].getZone(), firstRaidNumber, position, fromPosition)
	return true
end

function secondRaid.onStepIn(creature, item, position, fromPosition)
	if not creature:getPlayer() then
		return true
	end
	raid(SoulWarQuest.raids[secondRaidNumber].getZone(), secondRaidNumber, position, fromPosition)
	return true
end

function thirdRaid.onStepIn(creature, item, position, fromPosition)
	if not creature:getPlayer() then
		return true
	end
	raid(SoulWarQuest.raids[thirdRaidNumber].getZone(), thirdRaidNumber, position, fromPosition)
	return true
end

for _, pos in pairs(SoulWarQuest.raids[firstRaidNumber].sandTimerPositions) do
	firstRaid:position(pos)
end

for _, pos in pairs(SoulWarQuest.raids[secondRaidNumber].sandTimerPositions) do
	secondRaid:position(pos)
end

for _, position in pairs(SoulWarQuest.raids[thirdRaidNumber].sandTimerPositions) do
	thirdRaid:position(position)
end

firstRaid:register()
secondRaid:register()
thirdRaid:register()
