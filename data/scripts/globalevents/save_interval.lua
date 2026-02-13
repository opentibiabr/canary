local function serverSave(interval)
	if configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL_CLEAN_MAP) then
		cleanMap()
	end

	saveServer()
	local message = string.format(SAVE_INTERVAL_CONFIG_TIME > 1 and "Server save complete. Next save in %d %ss!" or "Server save complete. Next save in %d %s!", SAVE_INTERVAL_CONFIG_TIME, SAVE_INTERVAL_TYPE)
	Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	logger.info(message)
	Webhook.sendMessage("Server save", message, WEBHOOK_COLOR_WARNING)
end

local function getTimeLeftMs()
	local h, m = saveTimeStr:match("^(%d+):(%d+)$")
	h, m = tonumber(h), tonumber(m)

	local now = os.date("*t")
	local save = os.time({
		year = now.year,
		month = now.month,
		day = now.day,
		hour = h,
		min = m,
		sec = 0,
	})
	if save <= os.time() then
		save = save + 24 * 60 * 60
	end
	return (save - os.time()) * 1000
end

local save = GlobalEvent("save")

function save.onTime(interval)
	if not configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL) then
		return false
	end

	local WARNING = 60 * 1000
	local timeLeft = getTimeLeftMs()
	local delay = math.min(WARNING, timeLeft - 1000)

	if delay <= 0 then
		serverSave(interval)
		return true
	end

	local secs = math.floor(delay / 1000)
	local msg = string.format("The server will save all accounts within %d seconds. " .. "You might lag or freeze for 5 seconds, please find a safe place.", secs)

	Game.broadcastMessage(msg, MESSAGE_GAME_HIGHLIGHT)
	logger.info(msg)
	addEvent(serverSave, delay, interval)
	return true
end

if SAVE_INTERVAL_TIME ~= 0 then
	save:interval(SAVE_INTERVAL_CONFIG_TIME * SAVE_INTERVAL_TIME)
else
	return logger.error(string.format("[save.onTime] - Save interval type '%s' is not valid, use 'second', 'minute' or 'hour'", SAVE_INTERVAL_TYPE))
end

save:register()
