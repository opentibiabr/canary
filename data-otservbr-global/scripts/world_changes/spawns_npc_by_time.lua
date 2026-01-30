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
