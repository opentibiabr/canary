local function assertEqual(actual, expected, message)
	if actual ~= expected then
		error(string.format("%s: expected %s, got %s", message or "assertion failed", tostring(expected), tostring(actual)), 2)
	end
end

local function runScenario(version, databaseEnabled)
	local starts = 0
	local queries = 0

	logger = {
		error = function() end,
	}

	db = {
		storeQuery = function()
			queries = queries + 1
			if version == nil then
				return nil
			end
			return { version = version }
		end,
	}

	result = {
		getNumber = function(handle)
			return handle.version
		end,
		free = function() end,
	}

	GameplayAnalytics = {
		config = {
			enabled = true,
			databaseEnabled = databaseEnabled,
		},
		running = false,
	}

	function GameplayAnalytics.isEnabled()
		return GameplayAnalytics.config.enabled == true
	end

	function GameplayAnalytics.startRuntime()
		starts = starts + 1
		GameplayAnalytics.running = true
		return true
	end

	function GameplayAnalytics.status()
		return {
			enabled = GameplayAnalytics.config.enabled,
			running = GameplayAnalytics.running,
		}
	end

	local Analytics = dofile("data-otservbr-global/scripts/lib/gameplay_analytics_schema.lua")
	local started = Analytics.startRuntime()
	return Analytics, started, starts, queries
end

local missing, missingStarted, missingStarts, missingQueries = runScenario(nil, true)
assertEqual(missingStarted, false, "missing migration table blocks start")
assertEqual(missingStarts, 0, "core runtime not called for missing schema")
assertEqual(missingQueries, 1, "missing schema query count")
assertEqual(missing.config.enabled, false, "missing schema disables collection")
assertEqual(missing.running, false, "missing schema keeps runtime stopped")
assertEqual(missing.status().schemaReady, false, "missing schema readiness")
assertEqual(missing.status().schemaVersion, 0, "missing schema version")

local old, oldStarted, oldStarts = runScenario(2, true)
assertEqual(oldStarted, false, "old schema blocks start")
assertEqual(oldStarts, 0, "core runtime not called for old schema")
assertEqual(old.config.enabled, false, "old schema disables collection")
assertEqual(old.running, false, "old schema keeps runtime stopped")
assertEqual(old.status().schemaReady, false, "old schema readiness")
assertEqual(old.status().requiredSchemaVersion, 3, "required schema version")

local current, currentStarted, currentStarts, currentQueries = runScenario(3, true)
assertEqual(currentStarted, true, "current schema starts runtime")
assertEqual(currentStarts, 1, "core runtime called once")
assertEqual(currentQueries, 1, "current schema query count")
assertEqual(current.config.enabled, true, "current schema keeps collection enabled")
assertEqual(current.running, true, "current schema starts runtime state")
assertEqual(current.status().schemaReady, true, "current schema readiness")
assertEqual(current.status().schemaVersion, 3, "current schema version")

local disabled, disabledStarted, disabledStarts, disabledQueries = runScenario(nil, false)
assertEqual(disabledStarted, true, "database-disabled mode bypasses schema query")
assertEqual(disabledStarts, 1, "database-disabled core runtime call")
assertEqual(disabledQueries, 0, "database-disabled schema query count")
assertEqual(disabled.config.enabled, true, "database-disabled mode remains enabled")
assertEqual(disabled.status().schemaReady, true, "database-disabled schema readiness")

print("gameplay analytics schema guard runtime test passed")
