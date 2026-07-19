ExpeditionManager = ExpeditionManager or {}

local sessionsByKey = {}
local sessionsByPlayerId = {}

local function playerKey(player)
	return "p" .. player:getGuid()
end

function ExpeditionManager.getSessionByKey(key)
	return sessionsByKey[key]
end

function ExpeditionManager.getSessionByPlayer(player)
	if not player then
		return nil
	end
	return sessionsByPlayerId[player:getId()]
end

function ExpeditionManager.broadcastStatus(session)
	if not session then
		return
	end
	local player = Player(session.playerId)
	if player then
		ExpeditionProtocol.sendStatus(player, session)
	end
end

local function saveReturn(player)
	local pos = player:getPosition()
	player:setStorageValue(ExpeditionConfig.STORAGE_RETURN_X, pos.x)
	player:setStorageValue(ExpeditionConfig.STORAGE_RETURN_Y, pos.y)
	player:setStorageValue(ExpeditionConfig.STORAGE_RETURN_Z, pos.z)
end

local function loadReturn(player)
	local x = player:getStorageValue(ExpeditionConfig.STORAGE_RETURN_X)
	local y = player:getStorageValue(ExpeditionConfig.STORAGE_RETURN_Y)
	local z = player:getStorageValue(ExpeditionConfig.STORAGE_RETURN_Z)
	if x < 0 or y < 0 or z < 0 then
		local town = player:getTown()
		if town then
			return town:getTemplePosition()
		end
		return Position(32369, 32241, 7)
	end
	return Position(x, y, z)
end

local function markActive(player, expeditionId, slot)
	player:setStorageValue(ExpeditionConfig.STORAGE_ACTIVE, 1)
	player:setStorageValue(ExpeditionConfig.STORAGE_EXPEDITION_ID, expeditionId and 1 or -1)
	player:setStorageValue(ExpeditionConfig.STORAGE_SLOT, slot or -1)
	-- Store expedition id string via KV when available; storage holds flag only.
	local kv = player:kv()
	if kv then
		kv:set("expedition_id", expeditionId or "")
	end
end

local function clearActive(player)
	player:setStorageValue(ExpeditionConfig.STORAGE_ACTIVE, -1)
	player:setStorageValue(ExpeditionConfig.STORAGE_SLOT, -1)
	local kv = player:kv()
	if kv then
		kv:remove("expedition_id")
	end
end

function ExpeditionManager.join(player, expeditionId)
	if not player then
		return
	end
	if ExpeditionManager.getSessionByPlayer(player) then
		ExpeditionProtocol.sendError(player, "Already on an expedition.")
		return
	end

	local catalog = ExpeditionConfig.getById(expeditionId)
	if not catalog then
		ExpeditionProtocol.sendError(player, "Unknown expedition.")
		return
	end
	if player:getLevel() < (catalog.levelMin or 1) then
		ExpeditionProtocol.sendError(player, "Level too low for this expedition.")
		return
	end

	local slot, _ = ExpeditionInstance.allocate()
	if slot == nil then
		ExpeditionProtocol.sendError(player, "No expedition slots available.")
		return
	end

	local instance, err = ExpeditionInstance.build(slot, catalog.region, player:getGuid() + os.time())
	if not instance then
		ExpeditionInstance.free(slot)
		ExpeditionProtocol.sendError(player, err or "Failed to build expedition instance.")
		return
	end

	saveReturn(player)
	markActive(player, catalog.id, slot)

	local key = playerKey(player)
	local session = {
		key = key,
		playerId = player:getId(),
		guid = player:getGuid(),
		catalog = catalog,
		instance = instance,
		wave = 0,
		alive = 0,
		kills = 0,
		state = "idle",
		startedAt = os.time(),
	}
	sessionsByKey[key] = session
	sessionsByPlayerId[player:getId()] = session

	player:registerEvent("ExpeditionPlayerDeath")

	-- loadMapChunk is async; wait briefly, force a sync floor if needed, then teleport.
	local attempts = 0
	local function enterWhenReady()
		attempts = attempts + 1
		local s = ExpeditionManager.getSessionByKey(key)
		local p = Player(session.playerId)
		if not s or not p then
			return
		end
		if not ExpeditionInstance.hasGround(instance.entry) then
			if attempts >= 4 then
				ExpeditionInstance.ensureFloor(instance)
			elseif attempts < 16 then
				addEvent(enterWhenReady, 250)
				return
			else
				ExpeditionInstance.ensureFloor(instance)
			end
		end
		-- Cancel any client walk so AI owns movement.
		p:setFollowCreature(nil)
		p:teleportTo(instance.entry)
		p:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		ExpeditionProtocol.sendStatus(p, s)
		p:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Expedition started: " .. catalog.name)
		ExpeditionWaves.spawn(s)
		ExpeditionAI.start(s)
	end
	addEvent(enterWhenReady, 500)

	ExpeditionProtocol.sendStatus(player, session)
end

local function cleanupSession(session, player)
	if not session then
		return
	end
	ExpeditionAI.stop(session)
	ExpeditionWaves.clear(session)
	ExpeditionInstance.teardown(session.instance)
	sessionsByKey[session.key] = nil
	if session.playerId then
		sessionsByPlayerId[session.playerId] = nil
	end
	if player then
		sessionsByPlayerId[player:getId()] = nil
		player:unregisterEvent("ExpeditionPlayerDeath")
	end
end

function ExpeditionManager.leave(player, opts)
	opts = opts or {}
	if not player then
		return
	end
	local session = ExpeditionManager.getSessionByPlayer(player)
	if not session then
		if not opts.silent then
			ExpeditionProtocol.sendError(player, "Not on an expedition.")
		end
		return
	end

	local returnPos = loadReturn(player)
	cleanupSession(session, player)
	clearActive(player)
	player:teleportTo(returnPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	ExpeditionProtocol.sendEnded(player)
	if not opts.silent then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You left the expedition.")
	end
end

function ExpeditionManager.onDeath(player)
	if not player then
		return
	end
	local session = ExpeditionManager.getSessionByPlayer(player)
	if not session then
		return
	end
	-- Freeze the death scene: stop combat systems but keep instance tiles + corpse
	-- so the client can show "You are dead" over the expedition background.
	-- Teardown/teleport happens on next login (Ok / relogin), not here.
	ExpeditionAI.stop(session)
	ExpeditionWaves.clear(session)
	session.endedByDeath = true
	player:unregisterEvent("ExpeditionPlayerDeath")
end

function ExpeditionManager.onLogin(player)
	if not player then
		return
	end
	player:registerEvent("ExpeditionExtendedOpcode")

	local session = nil
	for _, s in pairs(sessionsByKey) do
		if s.guid == player:getGuid() then
			session = s
			break
		end
	end

	if session and session.endedByDeath then
		-- Player confirmed death (relogin). Leave the frozen expedition and return.
		local returnPos = loadReturn(player)
		cleanupSession(session, player)
		clearActive(player)
		player:setTraining(false)
		if returnPos then
			player:teleportTo(returnPos)
		end
		ExpeditionProtocol.sendEnded(player)
		return
	end

	if session then
		-- Re-bind player id after reconnect.
		sessionsByPlayerId[session.playerId] = nil
		session.playerId = player:getId()
		sessionsByPlayerId[player:getId()] = session
		player:registerEvent("ExpeditionPlayerDeath")
		ExpeditionAI.enablePersistence(player)
		ExpeditionProtocol.sendCatalog(player)
		ExpeditionProtocol.sendStatus(player, session)
		return
	end

	-- Rescue after restart: stranded in reserved area.
	if ExpeditionInstance.isInReservedArea(player:getPosition()) or player:getStorageValue(ExpeditionConfig.STORAGE_ACTIVE) == 1 then
		local returnPos = loadReturn(player)
		clearActive(player)
		player:setTraining(false)
		player:teleportTo(returnPos)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your expedition was interrupted. You were returned to safety.")
	end
end

function ExpeditionManager.onStartup()
	sessionsByKey = {}
	sessionsByPlayerId = {}
	if ExpeditionInstance and ExpeditionInstance.resetSlots then
		ExpeditionInstance.resetSlots()
	end
	logger.info("[Expedition] manager ready ({} catalog entries)", #ExpeditionConfig.Catalog)
end
