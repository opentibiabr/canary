local function serverSave(interval)
	if configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL_CLEAN_MAP) then
		cleanMap()
	end

	saveServer()
	local message = "Server save complete. Next save in %d %ss!"
	local messageSingle = "Server save complete. Next save in %d %s!"
	Webhook.sendMessage("Server save", message, WEBHOOK_COLOR_WARNING)
	if SAVE_INTERVAL_CONFIG_TIME > 1 then
		Game.broadcastMessage(string.format(message, SAVE_INTERVAL_CONFIG_TIME, SAVE_INTERVAL_TYPE), MESSAGE_GAME_HIGHLIGHT)
		logger.info(string.format(message, SAVE_INTERVAL_CONFIG_TIME, SAVE_INTERVAL_TYPE))
	else
		Game.broadcastMessage(string.format(messageSingle, SAVE_INTERVAL_CONFIG_TIME, SAVE_INTERVAL_TYPE), MESSAGE_GAME_HIGHLIGHT)
		logger.info(string.format(messageSingle, SAVE_INTERVAL_CONFIG_TIME, SAVE_INTERVAL_TYPE))
	end
end

local save = GlobalEvent("save")

function save.onTime(interval)
	local remainingTime = 60 * 1000
	if configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL) then
		local message = "The server will save all accounts within " .. (remainingTime / 1000) .. " seconds. \z
		You might lag or freeze for 5 seconds, please find a safe place."
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
		logger.info(string.format(message, SAVE_INTERVAL_CONFIG_TIME, SAVE_INTERVAL_TYPE))
		addEvent(serverSave, remainingTime, interval)
		return true
	end
	return not configManager.getBoolean(configKeys.TOGGLE_SAVE_INTERVAL)
end

if SAVE_INTERVAL_TIME ~= 0 then
	save:interval(SAVE_INTERVAL_CONFIG_TIME * SAVE_INTERVAL_TIME)
else
	return logger.error(string.format("[save.onTime] - Save interval type '%s' is not valid, use 'second', 'minute' or 'hour'", SAVE_INTERVAL_TYPE))
end

save:register()
