GameplayAnalytics = GameplayAnalytics or {}

local Analytics = GameplayAnalytics
Analytics.VERSION = 1
Analytics.sessions = Analytics.sessions or {}
Analytics.queue = Analytics.queue or {}
Analytics.running = Analytics.running or false
Analytics.lastFlush = Analytics.lastFlush or 0

local function loadConfig()
	local ok, value = pcall(dofile, "data-otservbr-global/scripts/config/gameplay_analytics.lua")
	if not ok or type(value) ~= "table" then
		logger.error("[GameplayAnalytics] Failed to load configuration: {}", tostring(value))
		return { enabled = false }
	end
	return value
end

Analytics.config = loadConfig()

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

local function uuid(playerId)
	return string.format("%08x-%04x-%04x-%04x-%012x", now() % 0xffffffff, math.random(0, 0xffff), math.random(0, 0xffff), math.random(0, 0xffff), (playerId * 100000 + math.random(0, 99999)) % 0xffffffffffff)
end

local function isExcluded(player)
	if not player or not player:isPlayer() then
		return true
	end
	if Analytics.config.includeStaff ~= true and player:getAccountType() > ACCOUNT_TYPE_NORMAL then
		return true
	end
	local name = player:getName()
	for _, excluded in ipairs(Analytics.config.excludedPlayerNames or {}) do
		if excluded:lower() == name:lower() then
			return true
		end
	end
	return false
end

local function partyInfo(player)
	local party = player:getParty()
	if not party then
		return 1, false
	end
	local count = 1
	local members = party:getMembers()
	if members then
		count = count + #members
	end
	return count, party:isSharedExperienceActive()
end

local function newSession(player)
	local timestamp = now()
	local vocation = player:getVocation()
	local vocationId = vocation and vocation:getId() or 0
	local partySize, sharedExperience = partyInfo(player)
	return {
		uuid = uuid(player:getGuid()),
		playerId = player:getGuid(),
		playerName = Analytics.config.anonymizePlayers and nil or player:getName(),
		vocationId = vocationId,
		levelStart = player:getLevel(),
		levelEnd = player:getLevel(),
		startedAt = timestamp,
		endedAt = timestamp,
		lastCombatAt = 0,
		combatStartedAt = 0,
		combatSeconds = 0,
		experienceRaw = 0,
		experienceFinal = 0,
		damageDealt = 0,
		damageReceived = 0,
		healingSelf = 0,
		healingOthers = 0,
		overhealing = 0,
		manaSpent = 0,
		monstersKilled = 0,
		deaths = 0,
		lootNpc = 0,
		lootMarket = 0,
		suppliesValue = 0,
		partySize = partySize,
		sharedExperience = sharedExperience,
		monsters = {},
		spells = {},
		damageTypes = {},
		supplies = {},
		loot = {},
	}
end

function Analytics.isEnabled()
	return Analytics.config.enabled == true
end

function Analytics.start(player)
	if not Analytics.isEnabled() or isExcluded(player) then
		return nil
	end
	local id = player:getGuid()
	if not Analytics.sessions[id] then
		Analytics.sessions[id] = newSession(player)
	end
	return Analytics.sessions[id]
end

function Analytics.get(player)
	if not player then
		return nil
	end
	return Analytics.sessions[player:getGuid()] or Analytics.start(player)
end

function Analytics.touchCombat(session)
	if not session then
		return
	end
	local timestamp = now()
	if session.combatStartedAt == 0 then
		session.combatStartedAt = timestamp
	end
	session.lastCombatAt = timestamp
	session.endedAt = timestamp
end

local function closeCombatWindow(session, timestamp)
	if session.combatStartedAt > 0 then
		session.combatSeconds = session.combatSeconds + math.max(0, timestamp - session.combatStartedAt)
		session.combatStartedAt = 0
	end
end

function Analytics.recordExperience(player, finalExperience, rawExperience)
	local session = Analytics.get(player)
	if not session then
		return
	end
	Analytics.touchCombat(session)
	session.experienceFinal = session.experienceFinal + math.max(0, tonumber(finalExperience) or 0)
	session.experienceRaw = session.experienceRaw + math.max(0, tonumber(rawExperience) or tonumber(finalExperience) or 0)
	session.levelEnd = player:getLevel()
end

local function damageBucket(session, damageType)
	local key = tonumber(damageType) or 0
	session.damageTypes[key] = session.damageTypes[key] or { dealt = 0, received = 0 }
	return session.damageTypes[key]
end

function Analytics.recordDamageDealt(player, target, amount, damageType)
	amount = math.max(0, tonumber(amount) or 0)
	if amount == 0 then
		return
	end
	local session = Analytics.get(player)
	if not session then
		return
	end
	Analytics.touchCombat(session)
	session.damageDealt = session.damageDealt + amount
	damageBucket(session, damageType).dealt = damageBucket(session, damageType).dealt + amount
	if Analytics.config.trackMonsters and target and target:isMonster() then
		local name = target:getName():lower()
		session.monsters[name] = session.monsters[name] or { kills = 0, damageDealt = 0, damageReceived = 0, experienceRaw = 0 }
		session.monsters[name].damageDealt = session.monsters[name].damageDealt + amount
	end
end

function Analytics.recordDamageReceived(player, attacker, amount, damageType)
	amount = math.max(0, tonumber(amount) or 0)
	if amount == 0 then
		return
	end
	local session = Analytics.get(player)
	if not session then
		return
	end
	Analytics.touchCombat(session)
	session.damageReceived = session.damageReceived + amount
	damageBucket(session, damageType).received = damageBucket(session, damageType).received + amount
	if Analytics.config.trackMonsters and attacker and attacker:isMonster() then
		local name = attacker:getName():lower()
		session.monsters[name] = session.monsters[name] or { kills = 0, damageDealt = 0, damageReceived = 0, experienceRaw = 0 }
		session.monsters[name].damageReceived = session.monsters[name].damageReceived + amount
	end
end

function Analytics.recordHealing(healer, target, effective, overhealing)
	effective = math.max(0, tonumber(effective) or 0)
	overhealing = math.max(0, tonumber(overhealing) or 0)
	local session = Analytics.get(healer)
	if not session then
		return
	end
	Analytics.touchCombat(session)
	if healer:getGuid() == target:getGuid() then
		session.healingSelf = session.healingSelf + effective
	else
		session.healingOthers = session.healingOthers + effective
	end
	session.overhealing = session.overhealing + overhealing
end

function Analytics.recordManaSpent(player, amount)
	local session = Analytics.get(player)
	if not session then
		return
	end
	session.manaSpent = session.manaSpent + math.max(0, tonumber(amount) or 0)
end

function Analytics.recordKill(player, target)
	if not target or not target:isMonster() then
		return
	end
	local session = Analytics.get(player)
	if not session then
		return
	end
	Analytics.touchCombat(session)
	session.monstersKilled = session.monstersKilled + 1
	if Analytics.config.trackMonsters then
		local name = target:getName():lower()
		session.monsters[name] = session.monsters[name] or { kills = 0, damageDealt = 0, damageReceived = 0, experienceRaw = 0 }
		session.monsters[name].kills = session.monsters[name].kills + 1
	end
end

function Analytics.recordDeath(player)
	local session = Analytics.get(player)
	if session then
		session.deaths = session.deaths + 1
		Analytics.finish(player, "death")
	end
end

function Analytics.recordSpell(player, spellName, damage, healing, mana, targets, critical)
	if Analytics.config.trackSpells ~= true then
		return
	end
	local session = Analytics.get(player)
	if not session then
		return
	end
	local key = tostring(spellName or "unknown"):lower()
	local spell = session.spells[key] or { casts = 0, targets = 0, damage = 0, healing = 0, mana = 0, critical = 0 }
	spell.casts = spell.casts + 1
	spell.targets = spell.targets + math.max(0, tonumber(targets) or 0)
	spell.damage = spell.damage + math.max(0, tonumber(damage) or 0)
	spell.healing = spell.healing + math.max(0, tonumber(healing) or 0)
	spell.mana = spell.mana + math.max(0, tonumber(mana) or 0)
	spell.critical = spell.critical + (critical and 1 or 0)
	session.spells[key] = spell
	Analytics.recordManaSpent(player, mana)
end

function Analytics.recordSupply(player, itemId, amount, unitValue)
	if Analytics.config.trackSupplies ~= true then
		return
	end
	local session = Analytics.get(player)
	if not session then
		return
	end
	itemId = tonumber(itemId) or 0
	amount = math.max(0, tonumber(amount) or 0)
	unitValue = math.max(0, tonumber(unitValue) or 0)
	local supply = session.supplies[itemId] or { amount = 0, unitValue = unitValue, totalValue = 0 }
	supply.amount = supply.amount + amount
	supply.unitValue = unitValue
	supply.totalValue = supply.totalValue + amount * unitValue
	session.supplies[itemId] = supply
	session.suppliesValue = session.suppliesValue + amount * unitValue
end

function Analytics.recordLoot(player, itemId, amount, npcValue, marketValue)
	if Analytics.config.trackLoot ~= true then
		return
	end
	local session = Analytics.get(player)
	if not session then
		return
	end
	itemId = tonumber(itemId) or 0
	amount = math.max(0, tonumber(amount) or 0)
	npcValue = math.max(0, tonumber(npcValue) or 0)
	marketValue = math.max(0, tonumber(marketValue) or 0)
	local loot = session.loot[itemId] or { amount = 0, npcValue = 0, marketValue = 0 }
	loot.amount = loot.amount + amount
	loot.npcValue = loot.npcValue + amount * npcValue
	loot.marketValue = loot.marketValue + amount * marketValue
	session.loot[itemId] = loot
	session.lootNpc = session.lootNpc + amount * npcValue
	session.lootMarket = session.lootMarket + amount * marketValue
end

function Analytics.enqueue(session)
	if #Analytics.queue >= clampInteger(Analytics.config.queueLimit, 100, nil, 10000) then
		logger.error("[GameplayAnalytics] Queue limit reached; dropping session {}", session.uuid)
		return false
	end
	Analytics.queue[#Analytics.queue + 1] = session
	return true
end

function Analytics.finish(player, reason)
	if not player then
		return
	end
	local id = player:getGuid()
	local session = Analytics.sessions[id]
	if not session then
		return
	end
	local timestamp = now()
	closeCombatWindow(session, timestamp)
	session.endedAt = timestamp
	session.levelEnd = player:getLevel()
	session.finishReason = reason or "unknown"
	Analytics.sessions[id] = nil
	local duration = session.endedAt - session.startedAt
	if duration >= clampInteger(Analytics.config.minimumSessionSeconds, 0, nil, 60) then
		Analytics.enqueue(session)
	end
end

local function sessionInsert(session)
	local nameSql = session.playerName and escaped(session.playerName) or "NULL"
	return string.format(
		[[INSERT INTO `analytics_sessions`
        (`session_uuid`,`player_id`,`player_name`,`vocation_id`,`level_start`,`level_end`,`started_at`,`ended_at`,`duration_seconds`,`combat_seconds`,`experience_raw`,`experience_final`,`damage_dealt`,`damage_received`,`healing_self`,`healing_others`,`overhealing`,`mana_spent`,`monsters_killed`,`deaths`,`loot_value_npc`,`loot_value_market`,`supplies_value`,`party_size`,`shared_experience`,`detail_level`,`analytics_version`)
        VALUES (%s,%d,%s,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d)]],
		escaped(session.uuid),
		session.playerId,
		nameSql,
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
		session.partySize,
		session.sharedExperience and 1 or 0,
		clampInteger(Analytics.config.detailLevel, 0, 2, 1),
		Analytics.VERSION
	)
end

local function insertDetails(session)
	local result = db.storeQuery("SELECT `id` FROM `analytics_sessions` WHERE `session_uuid` = " .. escaped(session.uuid) .. " LIMIT 1")
	if not result then
		return
	end
	local sessionId = result.getNumber(result, "id")
	result.free(result)
	if Analytics.config.trackMonsters then
		for name, data in pairs(session.monsters) do
			db.query(string.format("INSERT INTO `analytics_session_monsters` (`session_id`,`monster_name`,`kills`,`damage_dealt`,`damage_received`,`experience_raw`) VALUES (%d,%s,%d,%d,%d,%d)", sessionId, escaped(name), data.kills, data.damageDealt, data.damageReceived, data.experienceRaw))
		end
	end
	if Analytics.config.trackSpells then
		for name, data in pairs(session.spells) do
			db.query(string.format("INSERT INTO `analytics_session_spells` (`session_id`,`spell_name`,`casts`,`targets_hit`,`damage`,`healing`,`mana_spent`,`critical_hits`) VALUES (%d,%s,%d,%d,%d,%d,%d,%d)", sessionId, escaped(name), data.casts, data.targets, data.damage, data.healing, data.mana, data.critical))
		end
	end
	if Analytics.config.trackDamageTypes then
		for damageType, data in pairs(session.damageTypes) do
			db.query(string.format("INSERT INTO `analytics_session_damage_types` (`session_id`,`damage_type`,`damage_dealt`,`damage_received`) VALUES (%d,%d,%d,%d)", sessionId, damageType, data.dealt, data.received))
		end
	end
	if Analytics.config.trackSupplies then
		for itemId, data in pairs(session.supplies) do
			db.query(string.format("INSERT INTO `analytics_session_supplies` (`session_id`,`item_id`,`amount_used`,`unit_value`,`total_value`) VALUES (%d,%d,%d,%d,%d)", sessionId, itemId, data.amount, data.unitValue, data.totalValue))
		end
	end
	if Analytics.config.trackLoot then
		for itemId, data in pairs(session.loot) do
			db.query(string.format("INSERT INTO `analytics_session_loot` (`session_id`,`item_id`,`amount`,`npc_value`,`market_value`) VALUES (%d,%d,%d,%d,%d)", sessionId, itemId, data.amount, data.npcValue, data.marketValue))
		end
	end
end

function Analytics.flush()
	if Analytics.config.databaseEnabled ~= true or #Analytics.queue == 0 then
		Analytics.lastFlush = now()
		return true
	end
	local pending = Analytics.queue
	Analytics.queue = {}
	for _, session in ipairs(pending) do
		if db.query(sessionInsert(session)) then
			insertDetails(session)
		else
			logger.error("[GameplayAnalytics] Failed to persist session {}", session.uuid)
			if #Analytics.queue < clampInteger(Analytics.config.queueLimit, 100, nil, 10000) then
				Analytics.queue[#Analytics.queue + 1] = session
			end
		end
	end
	Analytics.lastFlush = now()
	return true
end

function Analytics.expireInactive()
	local timestamp = now()
	local timeout = clampInteger(Analytics.config.combatTimeoutSeconds, 10, nil, 120)
	for playerId, session in pairs(Analytics.sessions) do
		if session.lastCombatAt > 0 and timestamp - session.lastCombatAt >= timeout then
			local player = Player(playerId)
			if player then
				Analytics.finish(player, "combat-timeout")
				Analytics.start(player)
			else
				closeCombatWindow(session, timestamp)
				session.endedAt = timestamp
				Analytics.sessions[playerId] = nil
				Analytics.enqueue(session)
			end
		end
	end
end

function Analytics.tick()
	if not Analytics.running then
		return
	end
	Analytics.expireInactive()
	Analytics.flush()
	addEvent(Analytics.tick, clampInteger(Analytics.config.flushIntervalSeconds, 30, nil, 300) * 1000)
end

function Analytics.startRuntime()
	if not Analytics.isEnabled() or Analytics.running then
		return false
	end
	Analytics.running = true
	logger.info("[GameplayAnalytics] Enabled (detail level {}, flush {}s)", Analytics.config.detailLevel or 1, Analytics.config.flushIntervalSeconds or 300)
	addEvent(Analytics.tick, clampInteger(Analytics.config.flushIntervalSeconds, 30, nil, 300) * 1000)
	return true
end

function Analytics.stopRuntime()
	Analytics.running = false
	for playerId, _ in pairs(Analytics.sessions) do
		local player = Player(playerId)
		if player then
			Analytics.finish(player, "shutdown")
		end
	end
	Analytics.flush()
end

function Analytics.status()
	local active = 0
	for _ in pairs(Analytics.sessions) do
		active = active + 1
	end
	return {
		enabled = Analytics.isEnabled(),
		running = Analytics.running,
		activeSessions = active,
		queuedSessions = #Analytics.queue,
		lastFlush = Analytics.lastFlush,
		detailLevel = Analytics.config.detailLevel or 1,
	}
end

return Analytics
