local function serverSave(interval)
	if configManager.getBoolean(configKeys.TOGLE_SAVE_INTERVAL_CLEAN_MAP) then
		cleanMap()
	end

	saveServer()
	local message = "Server save complete. Next save in %d %s(s)!"
	Webhook.send("Server save", message, WEBHOOK_COLOR_WARNING)
	Game.broadcastMessage(string.format(message, SAVE_INTERVAL_CONFIG_TIME, SAVE_INTERVAL_TYPE), MESSAGE_GAME_HIGHLIGHT)
end

local save = GlobalEvent("save")

function save.onTime(interval)
	local remaningTime = 60 * 1000
	if configManager.getBoolean(configKeys.TOGLE_SAVE_INTERVAL) then
		local message = "The server will save all accounts within " .. (remaningTime/1000) .." seconds. \z
		You might lag or freeze for 5 seconds, please find a safe place."
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
		addEvent(serverSave, remaningTime, interval)
		return true
	end
	return not configManager.getBoolean(configKeys.TOGLE_SAVE_INTERVAL)
end

if SAVE_INTERVAL_TIME ~= 0 then
	save:interval(SAVE_INTERVAL_CONFIG_TIME * SAVE_INTERVAL_TIME)
else
	return Spdlog.error(string.format("Save interval type '%s' is not valid, use 'second', 'minute' or 'hour'", SAVE_INTERVAL_TYPE))
end

save:register()
