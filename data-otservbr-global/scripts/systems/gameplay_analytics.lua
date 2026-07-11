local Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics.lua")
Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_context.lua")
Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_schema.lua")
Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_batching.lua")
Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_reliability.lua")

local function registerPlayerEvents(player)
	player:registerEvent("GameplayAnalyticsHealth")
	player:registerEvent("GameplayAnalyticsMana")
	player:registerEvent("GameplayAnalyticsDeath")
	player:registerEvent("GameplayAnalyticsKill")
end

local startup = GlobalEvent("GameplayAnalyticsStartup")
function startup.onStartup()
	Analytics.startRuntime()
	return true
end
startup:register()

local shutdown = GlobalEvent("GameplayAnalyticsShutdown")
function shutdown.onShutdown()
	Analytics.stopRuntime()
	return true
end
shutdown:register()

local function ownerPlayer(source)
	if not source then
		return nil
	end
	if source:isPlayer() then
		return source
	end
	local master = source:getMaster()
	if master and master:isPlayer() then
		return master
	end
	return nil
end

local function recordPlayerDamage(creature, attacker, value, damageType)
	if value >= 0 then
		return
	end
	local amount = math.abs(value)
	local sourcePlayer = ownerPlayer(attacker)
	local targetPlayer = creature:isPlayer() and creature or nil

	if sourcePlayer and (Analytics.config.trackPvP or not targetPlayer) then
		Analytics.recordDamageDealt(sourcePlayer, creature, amount, damageType)
	end
	if targetPlayer and (Analytics.config.trackPvP or not sourcePlayer) then
		Analytics.recordDamageReceived(targetPlayer, attacker, amount, damageType)
	end
end

local health = CreatureEvent("GameplayAnalyticsHealth")
function health.onHealthChange(creature, attacker, primaryValue, primaryType, secondaryValue, secondaryType, origin)
	if not Analytics.isEnabled() then
		return primaryValue, primaryType, secondaryValue, secondaryType
	end

	recordPlayerDamage(creature, attacker, primaryValue, primaryType)
	recordPlayerDamage(creature, attacker, secondaryValue, secondaryType)

	local sourcePlayer = ownerPlayer(attacker)
	local targetPlayer = creature:isPlayer() and creature or nil
	local totalHealing = math.max(0, primaryValue) + math.max(0, secondaryValue)
	if totalHealing > 0 and sourcePlayer and targetPlayer then
		local missingBefore = math.max(0, targetPlayer:getMaxHealth() - targetPlayer:getHealth())
		local effective = math.min(totalHealing, missingBefore)
		Analytics.recordHealing(sourcePlayer, targetPlayer, effective, math.max(0, totalHealing - effective))
	end

	return primaryValue, primaryType, secondaryValue, secondaryType
end
health:register()

local mana = CreatureEvent("GameplayAnalyticsMana")
function mana.onManaChange(creature, attacker, primaryValue, primaryType, secondaryValue, secondaryType, origin)
	if Analytics.isEnabled() and creature:isPlayer() then
		local spent = math.max(0, -primaryValue) + math.max(0, -secondaryValue)
		if spent > 0 then
			Analytics.recordManaSpent(creature, spent)
		end
	end
	return primaryValue, primaryType, secondaryValue, secondaryType
end
mana:register()

local login = CreatureEvent("GameplayAnalyticsLogin")
function login.onLogin(player)
	if Analytics.isEnabled() then
		registerPlayerEvents(player)
	end
	return true
end
login:register()

local logout = CreatureEvent("GameplayAnalyticsLogout")
function logout.onLogout(player)
	if Analytics.isEnabled() then
		Analytics.finish(player, "logout")
	end
	return true
end
logout:register()

local death = CreatureEvent("GameplayAnalyticsDeath")
function death.onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if Analytics.isEnabled() and player:isPlayer() then
		Analytics.recordDeath(player)
	end
	return true
end
death:register()

local kill = CreatureEvent("GameplayAnalyticsKill")
function kill.onKill(player, target)
	if Analytics.isEnabled() and player:isPlayer() then
		Analytics.recordKill(player, target)
	end
	return true
end
kill:register()

local experienceCallback = EventCallback("GameplayAnalyticsExperience")
function experienceCallback.playerOnGainExperience(player, source, experienceValue, rawExperience)
	if Analytics.isEnabled() and source then
		Analytics.recordExperience(player, experienceValue, rawExperience, source)
	end
	return experienceValue
end
experienceCallback:register()

-- Outgoing damage to non-player creatures is measured through the engine-wide
-- drain-health callback. This also attributes summon damage to its player owner.
local drainHealthCallback = EventCallback("GameplayAnalyticsDrainHealth")
function drainHealthCallback.creatureOnDrainHealth(creature, attacker, primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor)
	if Analytics.isEnabled() and creature and not creature:isPlayer() then
		local sourcePlayer = ownerPlayer(attacker)
		local targetPlayer = ownerPlayer(creature)
		if sourcePlayer and (Analytics.config.trackPvP or not targetPlayer) then
			local primaryDamage = math.abs(tonumber(primaryValue) or 0)
			local secondaryDamage = math.abs(tonumber(secondaryValue) or 0)
			if primaryDamage > 0 then
				Analytics.recordDamageDealt(sourcePlayer, creature, primaryDamage, primaryType)
			end
			if secondaryDamage > 0 then
				Analytics.recordDamageDealt(sourcePlayer, creature, secondaryDamage, secondaryType)
			end
		end
	end

	return primaryType, primaryValue, secondaryType, secondaryValue, primaryColor, secondaryColor
end
drainHealthCallback:register()

local analyticsCommand = TalkAction("/analytics")
function analyticsCommand.onSay(player, words, param)
	if player:getAccountType() < ACCOUNT_TYPE_GAMEMASTER then
		return false
	end

	local command = param:trim():lower()
	if command == "flush" then
		local success = Analytics.flush(true)
		local status = Analytics.status()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Gameplay Analytics forced flush: success=%s, queued=%d, retrying=%d, deadLetters=%d.", tostring(success), status.queuedSessions, status.retryingSessions, status.deadLetterQueueSize))
		return false
	end

	if command == "deadletters" then
		local persisted = Analytics.persistDeadLetters()
		local status = Analytics.status()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Gameplay Analytics dead letters: persisted=%d, pending=%d, totalPersisted=%d, dropped=%d.", persisted, status.deadLetterQueueSize, status.persistedDeadLetters, status.droppedDeadLetters))
		return false
	end

	if command == "schema" then
		local ready = Analytics.checkSchema()
		local status = Analytics.status()
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Gameplay Analytics schema: ready=%s, current=%d, required=%d, error=%s.", tostring(ready), status.schemaVersion, status.requiredSchemaVersion, tostring(status.schemaError or "none")))
		return false
	end

	if command == "enable" then
		Analytics.config.enabled = true
		if not Analytics.startRuntime() then
			local status = Analytics.status()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Gameplay Analytics was not enabled: schema ready=%s, current=%d, required=%d, error=%s.", tostring(status.schemaReady), status.schemaVersion, status.requiredSchemaVersion, tostring(status.schemaError or "unknown")))
			return false
		end
		for _, onlinePlayer in ipairs(Game.getPlayers()) do
			registerPlayerEvents(onlinePlayer)
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Gameplay Analytics enabled until restart.")
		return false
	end

	if command == "disable" then
		Analytics.stopRuntime()
		Analytics.config.enabled = false
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Gameplay Analytics disabled until restart.")
		return false
	end

	local status = Analytics.status()
	player:sendTextMessage(
		MESSAGE_EVENT_ADVANCE,
		string.format(
			"Gameplay Analytics: enabled=%s, running=%s, schema=%d/%d ready=%s, active=%d, queued=%d, retrying=%d, deadLetters=%d, retries=%d, flushOk=%d, flushFail=%d, lastFlushMs=%d, oldestQueued=%ds, detail=%d, batchSize=%d, batchQueries=%d, detailRows=%d, contextSamples=%d, contextFinalized=%d, lastFlush=%d",
			tostring(status.enabled),
			tostring(status.running),
			status.schemaVersion,
			status.requiredSchemaVersion,
			tostring(status.schemaReady),
			status.activeSessions,
			status.queuedSessions,
			status.retryingSessions,
			status.deadLetterQueueSize,
			status.retriedSessions,
			status.successfulFlushes,
			status.failedFlushes,
			status.lastFlushDurationMs,
			status.oldestQueuedAgeSeconds,
			status.detailLevel,
			status.detailBatchSize,
			status.detailBatchQueries,
			status.detailRowsPersisted,
			status.contextSamples,
			status.contextFinalizedSessions,
			status.lastFlush
		)
	)
	return false
end
analyticsCommand:separator(" ")
analyticsCommand:groupType("god")
analyticsCommand:register()
