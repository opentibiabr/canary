local Analytics = GameplayAnalytics
if not Analytics then
	error("GameplayAnalytics must be loaded before gameplay_analytics_batching.lua")
end

if Analytics.batchingInstalled then
	return Analytics
end

Analytics.batchingInstalled = true
Analytics.batchStats = Analytics.batchStats or {
	detailBatchQueries = 0,
	detailRowsPersisted = 0,
	largestDetailBatch = 0,
}

local originalStatus = Analytics.status

local function now()
	return os.time()
end

local function clampInteger(value, minimum, maximum, fallback)
	value = tonumber(value)
	if not value then
		return fallback
	end
	value = math.floor(value)
	if value < minimum then
		return minimum
	end
	if maximum and value > maximum then
		return maximum
	end
	return value
end

local function escaped(value)
	return db.escapeString(tostring(value or ""))
end

local function nullableSql(value)
	if value == nil or value == "" then
		return "NULL"
	end
	return escaped(value)
end

local function sortedKeys(values)
	local keys = {}
	for key in pairs(values) do
		keys[#keys + 1] = key
	end
	table.sort(keys, function(left, right)
		if type(left) == type(right) then
			return left < right
		end
		return tostring(left) < tostring(right)
	end)
	return keys
end

local function detailBatchSize()
	return clampInteger(Analytics.config.detailBatchSize, 1, 1000, 250)
end

local function runDetailBatches(prefix, rows, updateClause)
	if #rows == 0 then
		return true
	end

	local success = true
	local batchSize = detailBatchSize()
	for first = 1, #rows, batchSize do
		local last = math.min(first + batchSize - 1, #rows)
		local batch = {}
		for index = first, last do
			batch[#batch + 1] = rows[index]
		end

		Analytics.batchStats.detailBatchQueries = Analytics.batchStats.detailBatchQueries + 1
		Analytics.batchStats.largestDetailBatch = math.max(Analytics.batchStats.largestDetailBatch, #batch)
		if db.query(prefix .. table.concat(batch, ",") .. updateClause) == true then
			Analytics.batchStats.detailRowsPersisted = Analytics.batchStats.detailRowsPersisted + #batch
		else
			success = false
		end
	end
	return success
end

local function sessionInsert(session)
	local partySize = tonumber(session.partySize) or 1
	local partySizeMin = tonumber(session.partySizeMin) or partySize
	local partySizeMax = tonumber(session.partySizeMax) or partySize
	local partySizeAvg = tonumber(session.partySizeAvg) or partySize
	local sharedExperienceSeconds = math.max(0, tonumber(session.sharedExperienceSeconds) or 0)
	local sharedExperienceRatio = math.max(0, math.min(1, tonumber(session.sharedExperienceRatio) or (session.sharedExperience and 1 or 0)))
	return string.format(
		[[INSERT INTO `analytics_sessions`
        (`session_uuid`,`player_id`,`player_name`,`vocation_id`,`level_start`,`level_end`,`started_at`,`ended_at`,`duration_seconds`,`combat_seconds`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_self`,`healing_others`,`overhealing`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`,`party_size`,`party_size_min`,`party_size_max`,`party_size_avg`,`shared_experience`,`shared_experience_seconds`,`shared_experience_ratio`,`party_vocations`,`server_version`,`hunt_area`,`detail_level`,`analytics_version`)
        VALUES (%s,%d,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%.2f,%d,%d,%.4f,%s,%s,%s,%d,%d)
        ON DUPLICATE KEY UPDATE
        `player_id`=VALUES(`player_id`),`player_name`=VALUES(`player_name`),`vocation_id`=VALUES(`vocation_id`),`level_start`=VALUES(`level_start`),`level_end`=VALUES(`level_end`),`started_at`=VALUES(`started_at`),`ended_at`=VALUES(`ended_at`),`duration_seconds`=VALUES(`duration_seconds`),`combat_seconds`=VALUES(`combat_seconds`),`experience_raw`=VALUES(`experience_raw`),`experience_final`=VALUES(`experience_final`),`damage_dealt`=VALUES(`damage_dealt`),`damage_received`=VALUES(`damage_received`),`healing_self`=VALUES(`healing_self`),`healing_others`=VALUES(`healing_others`),`overhealing`=VALUES(`overhealing`),`mana_spent`=VALUES(`mana_spent`),`monsters_killed`=VALUES(`monsters_killed`),`deaths`=VALUES(`deaths`),`loot_value_npc`=VALUES(`loot_value_npc`),`loot_value_market`=VALUES(`loot_value_market`),`supplies_value`=VALUES(`supplies_value`),`party_size`=VALUES(`party_size`),`party_size_min`=VALUES(`party_size_min`),`party_size_max`=VALUES(`party_size_max`),`party_size_avg`=VALUES(`party_size_avg`),`shared_experience`=VALUES(`shared_experience`),`shared_experience_seconds`=VALUES(`shared_experience_seconds`),`shared_experience_ratio`=VALUES(`shared_experience_ratio`),`party_vocations`=VALUES(`party_vocations`),`server_version`=VALUES(`server_version`),`hunt_area`=VALUES(`hunt_area`),`detail_level`=VALUES(`detail_level`),`analytics_version`=VALUES(`analytics_version`)]],
		escaped(session.uuid),
		session.playerId,
		nullableSql(session.playerName),
		session.vocationId,
		session.levelStart,
		session.levelEnd,
		session.startedAt,
		session.endedAt,
		math.max(0, session.endedAt - session.startedAt),
		session.combatSeconds,
		session.experienceRaw,
		session.experienceFinal,
		session.damageDealt,
		session.damageReceived,
		session.healingSelf,
		session.healingOthers,
		session.overhealing,
		session.manaSpent,
		session.monstersKilled,
		session.deaths,
		session.lootNpc,
		session.lootMarket,
		session.suppliesValue,
		partySize,
		partySizeMin,
		partySizeMax,
		partySizeAvg,
		session.sharedExperience and 1 or 0,
		sharedExperienceSeconds,
		sharedExperienceRatio,
		nullableSql(session.partyVocations),
		nullableSql(session.serverVersion),
		nullableSql(session.huntArea),
		clampInteger(Analytics.config.detailLevel, 0, 2, 1),
		Analytics.VERSION
	)
end

local function monsterRows(sessionId, session)
	local rows = {}
	if Analytics.config.trackMonsters ~= true then
		return rows
	end
	for _, name in ipairs(sortedKeys(session.monsters)) do
		local data = session.monsters[name]
		rows[#rows + 1] = string.format("(%d,%s,%d,%d,%d,%d)", sessionId, escaped(name), data.kills, data.damageDealt, data.damageReceived, data.experienceRaw)
	end
	return rows
end

local function spellRows(sessionId, session)
	local rows = {}
	if Analytics.config.trackSpells ~= true then
		return rows
	end
	for _, name in ipairs(sortedKeys(session.spells)) do
		local data = session.spells[name]
		rows[#rows + 1] = string.format("(%d,%s,%d,%d,%d,%d,%d,%d)", sessionId, escaped(name), data.casts, data.targets, data.damage, data.healing, data.mana, data.critical)
	end
	return rows
end

local function damageTypeRows(sessionId, session)
	local rows = {}
	if Analytics.config.trackDamageTypes ~= true then
		return rows
	end
	for _, damageType in ipairs(sortedKeys(session.damageTypes)) do
		local data = session.damageTypes[damageType]
		rows[#rows + 1] = string.format("(%d,%d,%d,%d)", sessionId, damageType, data.dealt, data.received)
	end
	return rows
end

local function supplyRows(sessionId, session)
	local rows = {}
	if Analytics.config.trackSupplies ~= true then
		return rows
	end
	for _, itemId in ipairs(sortedKeys(session.supplies)) do
		local data = session.supplies[itemId]
		rows[#rows + 1] = string.format("(%d,%d,%d,%d,%d)", sessionId, itemId, data.amount, data.unitValue, data.totalValue)
	end
	return rows
end

local function lootRows(sessionId, session)
	local rows = {}
	if Analytics.config.trackLoot ~= true then
		return rows
	end
	for _, itemId in ipairs(sortedKeys(session.loot)) do
		local data = session.loot[itemId]
		rows[#rows + 1] = string.format("(%d,%d,%d,%d,%d)", sessionId, itemId, data.amount, data.npcValue, data.marketValue)
	end
	return rows
end

local function insertDetails(session)
	local queryResult = db.storeQuery("SELECT `id` FROM `analytics_sessions` WHERE `session_uuid` = " .. escaped(session.uuid) .. " LIMIT 1")
	if not queryResult then
		logger.error("[GameplayAnalytics] Could not resolve persisted session {} for batched detail writes.", session.uuid)
		return false
	end
	local sessionId = result.getNumber(queryResult, "id")
	result.free(queryResult)

	local success = true
	success = runDetailBatches("INSERT INTO `analytics_session_monsters` (`session_id`,`monster_name`,`kills`,`damage_dealt`,`damage_received`,`experience_raw`) VALUES ", monsterRows(sessionId, session), " ON DUPLICATE KEY UPDATE `kills`=VALUES(`kills`),`damage_dealt`=VALUES(`damage_dealt`),`damage_received`=VALUES(`damage_received`),`experience_raw`=VALUES(`experience_raw`)") and success
	success = runDetailBatches(
		"INSERT INTO `analytics_session_spells` (`session_id`,`spell_name`,`casts`,`targets_hit`,`damage`,`healing`,`mana_spent`,`critical_hits`) VALUES ",
		spellRows(sessionId, session),
		" ON DUPLICATE KEY UPDATE `casts`=VALUES(`casts`),`targets_hit`=VALUES(`targets_hit`),`damage`=VALUES(`damage`),`healing`=VALUES(`healing`),`mana_spent`=VALUES(`mana_spent`),`critical_hits`=VALUES(`critical_hits`)"
	) and success
	success = runDetailBatches("INSERT INTO `analytics_session_damage_types` (`session_id`,`damage_type`,`damage_dealt`,`damage_received`) VALUES ", damageTypeRows(sessionId, session), " ON DUPLICATE KEY UPDATE `damage_dealt`=VALUES(`damage_dealt`),`damage_received`=VALUES(`damage_received`)") and success
	success = runDetailBatches("INSERT INTO `analytics_session_supplies` (`session_id`,`item_id`,`amount_used`,`unit_value`,`total_value`) VALUES ", supplyRows(sessionId, session), " ON DUPLICATE KEY UPDATE `amount_used`=VALUES(`amount_used`),`unit_value`=VALUES(`unit_value`),`total_value`=VALUES(`total_value`)") and success
	success = runDetailBatches("INSERT INTO `analytics_session_loot` (`session_id`,`item_id`,`amount`,`npc_value`,`market_value`) VALUES ", lootRows(sessionId, session), " ON DUPLICATE KEY UPDATE `amount`=VALUES(`amount`),`npc_value`=VALUES(`npc_value`),`market_value`=VALUES(`market_value`)") and success

	if not success then
		logger.error("[GameplayAnalytics] Failed to persist one or more batched details for session {}.", session.uuid)
	end
	return success
end

function Analytics.flush()
	if Analytics.config.databaseEnabled ~= true then
		Analytics.queue = {}
		Analytics.lastFlush = now()
		return true
	end
	if #Analytics.queue == 0 then
		Analytics.lastFlush = now()
		return true
	end

	local pending = Analytics.queue
	Analytics.queue = {}
	for _, session in ipairs(pending) do
		local persisted = db.query(sessionInsert(session)) == true
		if persisted then
			persisted = insertDetails(session)
		end
		if not persisted then
			logger.error("[GameplayAnalytics] Failed to persist batched session {}; scheduling retry.", session.uuid)
			Analytics.enqueue(session)
		end
	end
	Analytics.lastFlush = now()
	return true
end

function Analytics.status()
	local status = originalStatus()
	status.detailBatchSize = detailBatchSize()
	status.detailBatchQueries = Analytics.batchStats.detailBatchQueries
	status.detailRowsPersisted = Analytics.batchStats.detailRowsPersisted
	status.largestDetailBatch = Analytics.batchStats.largestDetailBatch
	return status
end

return Analytics
