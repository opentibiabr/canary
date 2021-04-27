local function ServerSave()
	if configManager.getBoolean(configKeys.SERVER_SAVE_CLEAN_MAP) then
		cleanMap()
	end
	if configManager.getBoolean(configKeys.SERVER_SAVE_CLOSE) then
		Game.setGameState(GAME_STATE_CLOSED)
	end
	if configManager.getBoolean(configKeys.SERVER_SAVE_SHUTDOWN) then
		Game.setGameState(GAME_STATE_SHUTDOWN)
	end
	-- Updating daily reward next server save.
	updateGlobalStorage(DailyReward.storages.lastServerSave, os.time())
	-- Reset gamestore exp boost count.
	db.query('UPDATE `player_storage` SET `value` = 0 WHERE `player_storage`.`key` = 51052')
end

local function ServerSaveWarning(time)
	-- minus one minutes
	local remaningTime = tonumber(time) - 60000
	if configManager.getBoolean(configKeys.SERVER_SAVE_NOTIFY_MESSAGE) then
		local message = "Server is saving game in " .. (remaningTime/60000) .." minute(s). Please logout."
		Webhook.send("Server save", message, WEBHOOK_COLOR_WARNING)
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	end
	-- if greater than one minute, schedule another warning
	-- else the next event will be the server save
	if remaningTime > 60000 then
		addEvent(ServerSaveWarning, 60000, remaningTime)
	else
		addEvent(ServerSave, 60000)
	end
end

-- Function that is called by the global events when it reaches the time configured
-- interval is the time between the event start and the the effective save, it will send an notify message every minute
local serversave = GlobalEvent("serversave")
function serversave.onTime(interval)
	local remaningTime = configManager.getNumber(configKeys.SERVER_SAVE_NOTIFY_DURATION) * 60000
	if configManager.getBoolean(configKeys.SERVER_SAVE_NOTIFY_MESSAGE) then
		local message = "Server is saving game in " .. (remaningTime/60000) .." minute(s). Please logout."
		Webhook.send("Server save", message, WEBHOOK_COLOR_WARNING)
		Game.broadcastMessage(message, MESSAGE_GAME_HIGHLIGHT)
	end
	addEvent(ServerSaveWarning, 60000, remaningTime)	-- Schedule next event in 1 minute(60000)
	return not configManager.getBoolean(configKeys.SERVER_SAVE_SHUTDOWN)
end
serversave:time("05:55:00")
serversave:register()
