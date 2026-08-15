return function(api)
	local soulpit = {
		authorizations = {},
	}
	api.soulpit = soulpit

	local function playerKey(player)
		if type(player.getId) == "function" then
			return player:getId()
		end
		return nil
	end

	local function playerSession(player)
		if type(player.getLastLoginSaved) ~= "function" then
			return nil
		end
		return player:getLastLoginSaved()
	end

	local function notify(player, text)
		if type(player.sendTextMessage) == "function" then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE or MESSAGE_STATUS_SMALL, text)
		end
	end

	local function logError(message, detail)
		local runtimeLogger = rawget(_G, "logger")
		if type(runtimeLogger) == "table" and type(runtimeLogger.error) == "function" then
			runtimeLogger.error(message, tostring(detail))
		end
	end

	local function abortEncounter(adapter, player)
		if type(adapter.abortSoloFight) ~= "function" then
			return
		end
		local ok, reason = pcall(adapter.abortSoloFight, player)
		if not ok then
			logError("[Taskboard.soulpit] Failed to abort Soulpit encounter: {}", reason)
		end
	end

	local function adapterCanOpen(player, adapter)
		if not api.isEnabled() or not api.supportsOfficialTaskboard(player) or type(adapter) ~= "table" or type(adapter.startSoloFight) ~= "function" then
			return false
		end
		if type(adapter.canOpenWindow) ~= "function" then
			return true
		end
		local ok, allowed = pcall(adapter.canOpenWindow, player)
		return ok and allowed == true
	end

	local function pruneAuthorizations(now)
		for key, authorization in pairs(soulpit.authorizations) do
			if authorization.expiresAt <= now then
				soulpit.authorizations[key] = nil
			end
		end
	end

	function soulpit.openWindow(player)
		local adapter = rawget(_G, "SoulPit")
		if not adapterCanOpen(player, adapter) then
			notify(player, "Soulpit encounters are not available on this server.")
			return false
		end
		local raceIds = api.catalog.getSoulpitRaceIds()
		if #raceIds == 0 then
			notify(player, "Soulpit is not configured on this server.")
			return false
		end

		local now = os.time()
		local key = playerKey(player)
		local session = playerSession(player)
		if key == nil or session == nil then
			notify(player, "Soulpit encounters are not available on this server.")
			return false
		end
		pruneAuthorizations(now)
		api.wire.sendSoulpit(player, raceIds)
		soulpit.authorizations[key] = {
			expiresAt = now + math.max(1, tonumber(api.config.soulpit.authorizationSeconds) or 0),
			session = session,
		}
		return true
	end

	local function consumeAuthorization(player)
		local key = playerKey(player)
		if key == nil then
			return false
		end
		local authorization = soulpit.authorizations[key]
		soulpit.authorizations[key] = nil
		return authorization ~= nil and authorization.expiresAt > os.time() and authorization.session == playerSession(player)
	end

	local function configuredRace(raceId)
		for _, configuredRaceId in ipairs(api.catalog.getSoulpitRaceIds()) do
			if configuredRaceId == raceId then
				return true
			end
		end
		return false
	end

	local function soulsealCost(entry)
		if not entry or not entry.monsterType or type(entry.monsterType.BestiaryStars) ~= "function" then
			return nil
		end
		local ok, value = pcall(entry.monsterType.BestiaryStars, entry.monsterType)
		local difficulty = ok and tonumber(value) or nil
		if not difficulty or difficulty % 1 ~= 0 or difficulty < 0 or difficulty > 5 then
			return nil
		end
		return (difficulty + 1) * 10
	end

	function soulpit.handleSelection(player, msg)
		if msg:getUnreadBytes() < 2 then
			return
		end
		local raceId = msg:getU16()
		if msg:getUnreadBytes() > 0 then
			return
		end
		if not consumeAuthorization(player) then
			notify(player, "The Soulpit entrance is no longer authorized.")
			return
		end
		local adapter = rawget(_G, "SoulPit")
		if not adapterCanOpen(player, adapter) then
			notify(player, "The Soulpit entrance is no longer authorized.")
			return
		end
		if not configuredRace(raceId) then
			notify(player, "That creature is not available in the Soulpit.")
			return
		end

		local entry = api.catalog.get(raceId)
		local cost = soulsealCost(entry)
		if not cost then
			notify(player, "That creature has no valid Soulpit difficulty.")
			return
		end
		local state = api.state.ensure(player)
		if state.general.soulseals < cost then
			notify(player, "You do not have enough Soulseals.")
			return
		end

		state.general.soulseals = state.general.soulseals - cost
		local ok, started = pcall(adapter.startSoloFight, player, entry.name)
		if not ok or started ~= true then
			state.general.soulseals = state.general.soulseals + cost
			abortEncounter(adapter, player)
			if not ok then
				logError("[Taskboard.soulpit] Failed to start Soulpit encounter: {}", started)
			end
			notify(player, "The Soulpit encounter could not be started.")
			return
		end

		local saveCallSucceeded, saved = pcall(api.state.save, player, state)
		if not saveCallSucceeded or saved ~= true then
			state.general.soulseals = state.general.soulseals + cost
			local rollbackCallSucceeded, rollbackSaved = pcall(api.state.save, player, state)
			abortEncounter(adapter, player)
			logError("[Taskboard.soulpit] Failed to persist Soulpit debit: {}", saveCallSucceeded and "save returned false" or saved)
			if not rollbackCallSucceeded or rollbackSaved ~= true then
				logError("[Taskboard.soulpit] Failed to persist Soulpit debit rollback: {}", rollbackCallSucceeded and "save returned false" or rollbackSaved)
			end
			notify(player, "Soulpit is unavailable right now.")
			return
		end

		api.wire.sendBalances(player, state)
	end
end
