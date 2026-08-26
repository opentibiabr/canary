return function(api)
	local catalog = {
		ready = false,
		entries = {},
		byRaceId = {},
	}

	api.catalog = catalog

	local function safeCall(object, methodName, ...)
		if not object or type(object[methodName]) ~= "function" then
			return nil
		end
		local ok, value = pcall(object[methodName], object, ...)
		return ok and value or nil
	end

	function catalog.rebuild()
		catalog.entries = {}
		catalog.byRaceId = {}

		local monsterTypes = Game.getMonsterTypes() or {}
		local discovered = 0
		local rewardBosses = 0
		local invalidRaceIds = 0
		local duplicateRaceIds = 0
		for fallbackName, monsterType in pairs(monsterTypes) do
			discovered = discovered + 1
			local raceId = tonumber(safeCall(monsterType, "raceId")) or 0
			local name = safeCall(monsterType, "name") or tostring(fallbackName)
			local rewardBoss = safeCall(monsterType, "isRewardBoss") == true
			if raceId > 0 and raceId <= 0xFFFF and name ~= "" and not rewardBoss and not catalog.byRaceId[raceId] then
				local entry = {
					raceId = raceId,
					name = name,
					stars = api.clampByte(safeCall(monsterType, "BestiaryStars") or 0),
					monsterType = monsterType,
				}
				catalog.byRaceId[raceId] = entry
				table.insert(catalog.entries, entry)
			elseif rewardBoss then
				rewardBosses = rewardBosses + 1
			elseif raceId <= 0 or raceId > 0xFFFF or name == "" then
				invalidRaceIds = invalidRaceIds + 1
			else
				duplicateRaceIds = duplicateRaceIds + 1
			end
		end

		table.sort(catalog.entries, function(left, right)
			return left.raceId < right.raceId
		end)
		catalog.ready = #catalog.entries > 0
		api.diagnostics.trace("catalog", "rebuild discovered={} usable={} rewardBosses={} invalid={} duplicates={} ready={}", discovered, #catalog.entries, rewardBosses, invalidRaceIds, duplicateRaceIds, catalog.ready)
	end

	local function ensureCatalog()
		if not catalog.ready then
			catalog.rebuild()
		end
		return catalog.entries
	end

	function catalog.get(raceId)
		ensureCatalog()
		return catalog.byRaceId[tonumber(raceId) or 0]
	end

	function catalog.isValidRace(raceId)
		return catalog.get(raceId) ~= nil
	end

	function catalog.getPool(difficulty)
		local entries = ensureCatalog()
		local settings = api.config.bounty.difficulties[api.normalizeDifficulty(difficulty, api.difficulty.beginner)]

		local pool = {}
		local function matchesDifficulty(entry)
			return entry.stars >= settings.minimumStars and entry.stars <= settings.maximumStars
		end

		for _, entry in ipairs(entries) do
			if matchesDifficulty(entry) then
				table.insert(pool, entry)
			end
		end

		if #pool == 0 then
			for _, entry in ipairs(entries) do
				table.insert(pool, entry)
			end
		end
		return pool
	end

	function catalog.randomUnique(amount, predicate, difficulty)
		local candidates = {}
		for _, entry in ipairs(catalog.getPool(difficulty)) do
			if not predicate or predicate(entry) then
				table.insert(candidates, entry)
			end
		end

		local result = {}
		amount = math.max(0, tonumber(amount) or 0)
		while #result < amount and #candidates > 0 do
			local index = math.random(1, #candidates)
			local entry = candidates[index]
			table.insert(result, entry)
			for candidateIndex = #candidates, 1, -1 do
				if candidates[candidateIndex].raceId == entry.raceId then
					table.remove(candidates, candidateIndex)
				end
			end
		end
		return result
	end

	function catalog.getSoulpitRaceIds()
		local raceIds = {}
		local added = {}
		for _, raceId in ipairs(api.config.soulpit.raceIds or {}) do
			local normalizedRaceId = tonumber(raceId)
			if normalizedRaceId and not added[normalizedRaceId] and catalog.isValidRace(normalizedRaceId) then
				added[normalizedRaceId] = true
				table.insert(raceIds, normalizedRaceId)
			end
		end
		table.sort(raceIds)
		return raceIds
	end

	function catalog.getWeeklyItems()
		local configuredItems = api.config.weeklyItems or {}
		local itemTypeFactory = rawget(_G, "ItemType")
		if itemTypeFactory == nil then
			return configuredItems
		end

		local usableItems = {}
		for _, configuredItem in ipairs(configuredItems) do
			local itemId = api.toFiniteNumber(configuredItem.id)
			local itemType
			if itemId and itemId == math.floor(itemId) and itemId > 0 and itemId <= 0xFFFF then
				local resolved, value = pcall(itemTypeFactory, itemId)
				itemType = resolved and value or nil
			end
			local resolvedId = tonumber(safeCall(itemType, "getId")) or 0
			local resolvedName = tostring(safeCall(itemType, "getName") or "")
			if resolvedId == itemId and resolvedName ~= "" then
				table.insert(usableItems, configuredItem)
			else
				api.diagnostics.trace("catalog", "ignored invalid weekly delivery item id={}", tostring(configuredItem.id))
			end
		end
		return usableItems
	end
end
