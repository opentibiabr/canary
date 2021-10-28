local saveIntervalType = configManager.getString(configKeys.SAVE_INTERVAL_TYPE)
local configTime = configManager.getNumber(configKeys.SAVE_INTERVAL_TIME)
local time
if saveIntervalType == "second" then
	time = 1000
elseif saveIntervalType == "minute" then
	time = 60 * 1000
elseif saveIntervalType == "hour" then
	time = 60 * 60 * 1000
else
	time = 0;
end

local function serverSave(interval)
	if configManager.getBoolean(configKeys.TOGLE_SAVE_INTERVAL_CLEAN_MAP) then
		cleanMap()
	end
	
	saveServer()
	local message = "Server save complete. Next save in %d %s(s)!"
	Webhook.send("Server save", message, WEBHOOK_COLOR_WARNING)
	Game.broadcastMessage(string.format(message, configTime, saveIntervalType), MESSAGE_GAME_HIGHLIGHT)
end

local save = GlobalEvent("save")
function save.onTime(interval)
	if time == 0 then
		return Spdlog.error(string.format("Save interval type '%s' is not valid, use 'second', 'minute' or 'hour'", saveIntervalType))
	end

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

if time ~= 0 then
	save:interval(configTime * time)
end

save:register()
