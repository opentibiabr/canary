local save = GlobalEvent("save")
local warningDelay = 60 * 1000
local configuredInterval = SAVE_INTERVAL_CONFIG_TIME * SAVE_INTERVAL_TIME
local isSaveScheduled = false

local function serverSave()
	isSaveScheduled = false

	if configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL_CLEAN_MAP) then
		cleanMap()
	end

	logger.info("Starting interval server save...")
	saveServer()

	local message = string.format(
		SAVE_INTERVAL_CONFIG_TIME > 1 and "Server save complete. Next save in %d %ss!" or "Server save complete. Next save in %d %s!",
		SAVE_INTERVAL_CONFIG_TIME,
		SAVE_INTERVAL_TYPE
	)
	Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	logger.info(message)
	Webhook.sendMessage("Server save", message, WEBHOOK_COLOR_WARNING)
end

function save.onThink(interval)
	if not configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL) then
		return true
	end

	if isSaveScheduled then
		return true
	end

	if configuredInterval > warningDelay then
		local message = "The server will save all accounts within 60 seconds. You might lag or freeze briefly; please find a safe place."
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
		logger.info(message)
		isSaveScheduled = true
		addEvent(serverSave, warningDelay)
	else
		serverSave()
	end

	return true
end

if SAVE_INTERVAL_TIME == 0 then
	return logger.error(string.format("[save.onThink] - Save interval type '%s' is not valid, use 'second', 'minute' or 'hour'", SAVE_INTERVAL_TYPE))
end

save:interval(configuredInterval)
save:register()
