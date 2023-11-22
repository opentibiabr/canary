--- Get the next occurrence of a time string
---@param timeStr string The time string in the format HH:MM:SS
---@return number|nil The timestamp of the next occurrence, or nil if the string is invalid
local function GetNextOccurrence(timeStr)
	local hours, minutes, seconds = string.match(timeStr, "(%d+):(%d+):(%d+)")
	if not hours or not minutes or not seconds then
		error("Invalid time string format.")
		return nil
	end

	hours = tonumber(hours)
	minutes = tonumber(minutes)
	seconds = tonumber(seconds)

	local currentTime = os.time()
	local dateTable = os.date("*t", currentTime)

	dateTable.hour = hours
	dateTable.min = minutes
	dateTable.sec = seconds

	local nextTime = os.time(dateTable)

	if nextTime <= currentTime then
		nextTime = nextTime + (24 * 60 * 60)
	end

	return nextTime
end


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
