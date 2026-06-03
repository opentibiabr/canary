local activeNpcRefs = {}

local npcSpawns = {
	{
		name = "Ghostly Wolf",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(33332, 32052, 7),
	},
	{
		name = "Talila",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(33504, 32222, 7),
	},
	{
		name = "Valindara",
		spawnPeriod = LIGHT_STATE_SUNRISE,
		despawnPeriod = LIGHT_STATE_SUNSET,
		position = Position(33504, 32222, 7),
	},
	{
		name = "Evrard the Miller",
		spawnPeriod = LIGHT_STATE_SUNRISE,
		despawnPeriod = LIGHT_STATE_SUNSET,
		position = Position(32422, 32464, 7),
	},
	{
		name = "Evrard",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(32404, 32493, 6),
	},
	{
		name = "Wes the Blacksmith (Day)",
		spawnPeriod = LIGHT_STATE_SUNRISE,
		despawnPeriod = LIGHT_STATE_SUNSET,
		position = Position(32423, 32481, 5),
	},
	{
		name = "Wes the Blacksmith (Night)",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(32374, 32467, 6),
	},
	{
		name = "Onfroi (Day)",
		spawnPeriod = LIGHT_STATE_SUNRISE,
		despawnPeriod = LIGHT_STATE_SUNSET,
		position = Position(32428, 32489, 5),
	},
	{
		name = "Onfroi (Night)",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(32429, 32487, 2),
	},
	{
		name = "Dal the Huntress (Day)",
		spawnPeriod = LIGHT_STATE_SUNRISE,
		despawnPeriod = LIGHT_STATE_SUNSET,
		position = Position(32436, 32492, 5),
	},
	{
		name = "Dal the Huntress (Night)",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(32436, 32494, 4),
	},
	{
		name = "Jehan The Baker (Day)",
		spawnPeriod = LIGHT_STATE_SUNRISE,
		despawnPeriod = LIGHT_STATE_SUNSET,
		position = Position(32421, 32481, 4),
	},
	{
		name = "Jehan The Baker (Night)",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(32391, 32458, 6),
	},
	{
		name = "Fral the Butcher (Day)",
		spawnPeriod = LIGHT_STATE_SUNRISE,
		despawnPeriod = LIGHT_STATE_SUNSET,
		position = Position(32445, 32480, 4),
	},
	{
		name = "Fral the Butcher (Night)",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(32399, 32496, 6),
	},
	{
		name = "Fitzmaurice",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(32411, 32486, 7),
	},
	{
		name = "Kesar the Younger (Day)",
		spawnPeriod = LIGHT_STATE_SUNRISE,
		despawnPeriod = LIGHT_STATE_SUNSET,
		position = Position(32365, 32478, 2),
	},
	{
		name = "Kesar the Younger (Night)",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(32368, 32473, 3),
	},
	{
		name = "Kesar's Valet (Day)",
		spawnPeriod = LIGHT_STATE_SUNRISE,
		despawnPeriod = LIGHT_STATE_SUNSET,
		position = Position(32367, 32476, 2),
	},
	{
		name = "Kesar's Valet (Night)",
		spawnPeriod = LIGHT_STATE_SUNSET,
		despawnPeriod = LIGHT_STATE_SUNRISE,
		position = Position(32372, 32473, 3),
	},
}

local spawnsNpcByTime = GlobalEvent("SpawnsNpcByTime")

function spawnsNpcByTime.onPeriodChange(period)
	local npcsToRemove = {}
	local npcsToAdd = {}
	for i, npcData in ipairs(npcSpawns) do
		if npcData.despawnPeriod == period and activeNpcRefs[i] then
			table.insert(npcsToRemove, {
				index = i,
				data = npcData,
			})
		elseif npcData.spawnPeriod == period and not activeNpcRefs[i] then
			table.insert(npcsToAdd, {
				index = i,
				data = npcData,
			})
		end
	end
	for _, entry in ipairs(npcsToRemove) do
		local npc = Creature(activeNpcRefs[entry.index])
		if npc and npc:isNpc() then
			npc:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			npc:remove()
		end
		activeNpcRefs[entry.index] = nil
	end
	if #npcsToAdd > 0 then
		addEvent(function()
			for _, entry in ipairs(npcsToAdd) do
				local npc = Game.createNpc(entry.data.name, entry.data.position)
				if npc then
					npc:setMasterPos(entry.data.position)
					npc:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					activeNpcRefs[entry.index] = npc:getId()
				else
					logger.error("NpcByTime: Failed to spawn:", entry.data.name)
				end
			end
		end, 5000)
	end

	return true
end

spawnsNpcByTime:register()

local spawnsNpcBySpawn = GlobalEvent("SpawnsNpcBySpawn")

function spawnsNpcBySpawn.onStartup()
	local currentPeriod = LIGHT_STATE_SUNRISE

	local mode = getTibiaTimerDayOrNight()
	if mode == "night" then
		currentPeriod = LIGHT_STATE_SUNSET
	else
		currentPeriod = LIGHT_STATE_SUNRISE
	end

	local npcsToAdd = {}

	for i, npcData in ipairs(npcSpawns) do
		if npcData.spawnPeriod == currentPeriod then
			table.insert(npcsToAdd, {
				index = i,
				data = npcData,
			})
		end
	end

	if #npcsToAdd > 0 then
		addEvent(function()
			for _, entry in ipairs(npcsToAdd) do
				local npc = Game.createNpc(entry.data.name, entry.data.position)
				if npc then
					npc:setMasterPos(entry.data.position)
					npc:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					activeNpcRefs[entry.index] = npc:getId()
					logger.info("NpcByTime: " .. entry.data.name .. " spawned successfully.")
				else
					logger.error("NpcByTime: Failed to spawn:", entry.data.name)
				end
			end
		end, 5000)
	else
		logger.info("NpcByTime: No NPCs to spawn in the current period.")
	end

	return true
end

spawnsNpcBySpawn:register()
