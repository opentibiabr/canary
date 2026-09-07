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

local save = GlobalEvent("save")

function save.onTime(interval)
	if not configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL) then
		return true
	end

	if isSaveScheduled then
		return true
	end

	local warningDuration = 60 * 1000
	if interval <= warningDuration then
		serverSave(interval)
		return true
	end

	local warningSeconds = math.floor(warningDuration / 1000)
	local message = "The server will save all accounts within " .. warningSeconds .. " seconds. You might lag or freeze for 5 seconds, please find a safe place."
	Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	logger.info(message)
	isSaveScheduled = true
	addEvent(serverSave, warningDuration, interval)

	return true
end

if SAVE_INTERVAL_TIME ~= 0 then
	save:interval(SAVE_INTERVAL_CONFIG_TIME * SAVE_INTERVAL_TIME)
else
	return logger.error(string.format("[save.onTime] - Save interval type '%s' is not valid, use 'second', 'minute' or 'hour'", SAVE_INTERVAL_TYPE))
end

save:register()
