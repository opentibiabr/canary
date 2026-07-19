ExpeditionWaves = ExpeditionWaves or {}

-- monsterId -> session key
local monsterOwners = {}

function ExpeditionWaves.spawn(session)
	if not session or not session.instance or not session.catalog then
		return
	end
	local catalog = session.catalog
	local count = math.random(catalog.waveMin or 1, catalog.waveMax or 8)
	session.alive = 0
	session.wave = (session.wave or 0) + 1
	session.state = "hunting"
	session.waitingEvent = nil

	if not ExpeditionInstance.hasGround(session.instance.entry) then
		ExpeditionInstance.ensureFloor(session.instance)
	end

	for _ = 1, count do
		local name = catalog.creatures[math.random(1, #catalog.creatures)]
		local pos = ExpeditionInstance.randomWalkable(session.instance)
		if pos then
			local monster = Game.createMonster(name, pos, true, true)
			if monster then
				monster:registerEvent("ExpeditionMonsterDeath")
				monsterOwners[monster:getId()] = session.key
				session.alive = session.alive + 1
			else
				logger.warn("[Expedition] failed to create monster '{}' at {}", name, pos)
			end
		end
	end

	if session.alive == 0 then
		-- Retry shortly if spawn failed (tiles not ready yet).
		session.waitingEvent = addEvent(function()
			local s = ExpeditionManager.getSessionByKey(session.key)
			if s then
				ExpeditionWaves.spawn(s)
			end
		end, 1500)
	else
		ExpeditionManager.broadcastStatus(session)
	end
end

function ExpeditionWaves.onMonsterDeath(creature)
	if not creature then
		return
	end
	local monsterId = creature:getId()
	local key = monsterOwners[monsterId]
	monsterOwners[monsterId] = nil
	if not key then
		return
	end
	local session = ExpeditionManager.getSessionByKey(key)
	if not session then
		return
	end

	session.alive = math.max(0, (session.alive or 1) - 1)
	session.kills = (session.kills or 0) + 1
	ExpeditionManager.broadcastStatus(session)

	if session.alive <= 0 and session.state == "hunting" then
		session.state = "waiting"
		local delay = session.catalog.spawnIntervalMs or ExpeditionConfig.WAVE_RESPAWN_MS
		session.waitingEvent = addEvent(function()
			local s = ExpeditionManager.getSessionByKey(key)
			if s and s.state == "waiting" then
				ExpeditionWaves.spawn(s)
			end
		end, delay)
		ExpeditionManager.broadcastStatus(session)
	end
end

function ExpeditionWaves.clear(session)
	if not session then
		return
	end
	if session.waitingEvent then
		stopEvent(session.waitingEvent)
		session.waitingEvent = nil
	end
	if session.instance and session.instance.zone then
		session.instance.zone:removeMonsters()
	end
	for mid, key in pairs(monsterOwners) do
		if key == session.key then
			monsterOwners[mid] = nil
		end
	end
	session.alive = 0
end
