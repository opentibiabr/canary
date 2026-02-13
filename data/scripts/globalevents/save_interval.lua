local saveTimeStr = "00:00"
local isSaveScheduled = false

local function serverSave(interval)
	isSaveScheduled = false
	if configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL_CLEAN_MAP) then
		cleanMap()
	end

	saveServer()
	local message = string.format(SAVE_INTERVAL_CONFIG_TIME > 1 and "Server save complete. Next save in %d %ss!" or "Server save complete. Next save in %d %s!", SAVE_INTERVAL_CONFIG_TIME, SAVE_INTERVAL_TYPE)
	Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	logger.info(message)
	Webhook.sendMessage("Server save", message, WEBHOOK_COLOR_WARNING)
end

local function getTimeLeftMs(timeStr)
	if type(timeStr) ~= "string" then
		return 0
	end

	local hStr, mStr = timeStr:match("^(%d%d):(%d%d)$")
	if not hStr or not mStr then
		return 0
	end

	local h, m = tonumber(hStr), tonumber(mStr)
	if not h or not m or h < 0 or h > 23 or m < 0 or m > 59 then
		return 0
	end

	local nowTs = os.time()
	local nowDate = os.date("*t", nowTs)
	local saveTs = os.time({
		year = nowDate.year,
		month = nowDate.month,
		day = nowDate.day,
		hour = h,
		min = m,
		sec = 0,
	})

	if saveTs <= nowTs then
		saveTs = saveTs + 24 * 60 * 60
	end

	return (saveTs - nowTs) * 1000
end

local save = GlobalEvent("save")

function save.onTime(interval)
	if not configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL) then
		return true
	end

	if isSaveScheduled then
		return true
	end

	local WARNING = 60 * 1000
	local timeLeft = getTimeLeftMs(saveTimeStr)

	if timeLeft > WARNING then
		return true
	end

	if timeLeft <= 1000 then
		serverSave(interval)
	else
		local secs = math.floor(timeLeft / 1000)
		local msg = string.format("The server will save all accounts within %d seconds. " .. "You might lag or freeze for 5 seconds, please find a safe place.", secs)
		Game.broadcastMessage(msg, MESSAGE_GAME_HIGHLIGHT)
		logger.info(msg)
		isSaveScheduled = true
		addEvent(serverSave, timeLeft - 1000, interval)
	end

	return true
end

if SAVE_INTERVAL_TIME ~= 0 then
	save:interval(SAVE_INTERVAL_CONFIG_TIME * SAVE_INTERVAL_TIME)
else
	return logger.error(string.format("[save.onTime] - Save interval type '%s' is not valid, use 'second', 'minute' or 'hour'", SAVE_INTERVAL_TYPE))
end

save:register()
