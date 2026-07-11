local Analytics = GameplayAnalytics
if not Analytics then
	error("GameplayAnalytics must be loaded before gameplay_analytics_schema.lua")
end

if Analytics.schemaGuardInstalled then
	return Analytics
end

Analytics.schemaGuardInstalled = true
Analytics.REQUIRED_SCHEMA_VERSION = 2
Analytics.schemaState = Analytics.schemaState or {
	ready = false,
	version = 0,
	checkedAt = 0,
	lastError = "not checked",
}

local originalStartRuntime = Analytics.startRuntime
local originalStatus = Analytics.status

local function now()
	return os.time()
end

function Analytics.checkSchema()
	Analytics.schemaState.checkedAt = now()
	if Analytics.config.databaseEnabled ~= true then
		Analytics.schemaState.ready = true
		Analytics.schemaState.version = Analytics.REQUIRED_SCHEMA_VERSION
		Analytics.schemaState.lastError = nil
		return true
	end

	local queryResult = db.storeQuery("SELECT COALESCE(MAX(`version`), 0) AS `version` FROM `analytics_schema_migrations`")
	if not queryResult then
		Analytics.schemaState.ready = false
		Analytics.schemaState.version = 0
		Analytics.schemaState.lastError = "migration table missing or unreadable"
		logger.error("[GameplayAnalytics] Schema check failed: {}. Run tools/analytics/migrate_gameplay_analytics.sh.", Analytics.schemaState.lastError)
		return false
	end

	local version = result.getNumber(queryResult, "version")
	result.free(queryResult)
	Analytics.schemaState.version = tonumber(version) or 0
	Analytics.schemaState.ready = Analytics.schemaState.version >= Analytics.REQUIRED_SCHEMA_VERSION
	if Analytics.schemaState.ready then
		Analytics.schemaState.lastError = nil
		return true
	end

	Analytics.schemaState.lastError = string.format("schema version %d is older than required version %d", Analytics.schemaState.version, Analytics.REQUIRED_SCHEMA_VERSION)
	logger.error("[GameplayAnalytics] {}. Run tools/analytics/migrate_gameplay_analytics.sh.", Analytics.schemaState.lastError)
	return false
end

function Analytics.startRuntime()
	if Analytics.isEnabled() and not Analytics.checkSchema() then
		Analytics.config.enabled = false
		Analytics.running = false
		logger.error("[GameplayAnalytics] Collection disabled until the schema is migrated and Analytics is enabled again.")
		return false
	end
	return originalStartRuntime()
end

function Analytics.status()
	local status = originalStatus()
	status.schemaReady = Analytics.schemaState.ready
	status.schemaVersion = Analytics.schemaState.version
	status.requiredSchemaVersion = Analytics.REQUIRED_SCHEMA_VERSION
	status.schemaCheckedAt = Analytics.schemaState.checkedAt
	status.schemaError = Analytics.schemaState.lastError
	return status
end

return Analytics
