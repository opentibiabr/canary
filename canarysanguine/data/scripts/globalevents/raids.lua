local serverSaveTime = GetNextOccurrence(configManager.getString(configKeys.GLOBAL_SERVER_SAVE_TIME))
local stopExecutionAt = serverSaveTime - ParseDuration("1h") / ParseDuration("1s") -- stop rolling raids 1 hour before server save
local raidCheck = GlobalEvent("raids.check.onThink")

function raidCheck.onThink(interval, lastExecution)
	if os.time() > stopExecutionAt then
		return true
	end

	for _, raid in pairs(Raid.registry) do
		raid:tryStart()
	end
	return true
end

raidCheck:interval(ParseDuration(Raid.checkInterval))
raidCheck:register()
