local experienceMultiplier = configManager.getFloat(configKeys.LIVESTREAM_EXPERIENCE_MULTIPLIER)
local bonusPercent = math.floor(((experienceMultiplier or 1.0) - 1.0) * 100 + 0.5)

local playersStreaming = {}

local helpMessages = {
	"Available commands:\n",
	"!livestream on - enables the stream",
	"!livestream off - disables the stream",
	"!livestream desc, description (or empty for remove) - sets description about your livestream",
	"!livestream desc, remove/delete - removes description",
	"!livestream password, password - sets a password on the stream",
	"!livestream password off - disables the password protection",
	"!livestream kick, name - kick a spectator from your stream",
	"!livestream ban, name - locks spectator IP from joining your stream",
	"!livestream unban, name - removes banishment lock",
	"!livestream bans - shows banished spectators list",
	"!livestream mute, name - mutes selected spectator from chat",
	"!livestream unmute, name - removes mute",
	"!livestream mutes - shows muted spectators list",
	"!livestream show - displays the amount and nicknames of current spectators",
	"!livestream status - displays stream status",
}

local function containsName(list, name)
	name = name:lower()
	for index, value in ipairs(list) do
		if value:lower() == name then
			return index
		end
	end
	return nil
end

local function removeNameOccurrences(list, name)
	local removed = false
	name = name:lower()
	for index = #list, 1, -1 do
		if list[index]:lower() == name then
			table.remove(list, index)
			removed = true
		end
	end
	return removed
end

local function joinNames(list)
	return table.concat(list, ", ")
end

local function toBoolean(value)
	return value == true or value == 1 or value == "1"
end

local function normalizeData(data)
	data.names = data.names or {}
	data.mutes = data.mutes or {}
	data.bans = data.bans or {}
	data.kick = {}
	data.password = data.password or ""
	data.description = data.description or ""
	data.broadcast = toBoolean(data.broadcast)
	return data
end

local livestreamTableChecked = false
local livestreamTableAvailable = false

local function ensureLivestreamTable()
	if livestreamTableChecked then
		return livestreamTableAvailable
	end

	livestreamTableAvailable = db.tableExists("active_livestream_casters")
	livestreamTableChecked = true
	if not livestreamTableAvailable then
		logger.error("[Livestream] Missing active_livestream_casters table. Run database migrations before enabling livestream persistence.")
	end

	return livestreamTableAvailable
end

local function executeLivestreamQuery(query)
	if not ensureLivestreamTable() then
		return false
	end

	return db.query(query)
end

local function updateLivestreamStatus(player, status, viewers)
	return executeLivestreamQuery("UPDATE `active_livestream_casters` SET `livestream_status` = " .. status .. ", `livestream_viewers` = " .. viewers .. " WHERE `caster_id` = " .. player:getGuid())
end

local function upsertLivestreamStatus(player, status, viewers)
	return executeLivestreamQuery("INSERT INTO `active_livestream_casters` (`caster_id`, `livestream_status`, `livestream_viewers`) VALUES (" .. player:getGuid() .. ", " .. status .. ", " .. viewers .. ") ON DUPLICATE KEY UPDATE `livestream_status` = " .. status .. ", `livestream_viewers` = " .. viewers)
end

local function updateLivestreamViewerCount(player)
	return executeLivestreamQuery("UPDATE `active_livestream_casters` SET `livestream_viewers` = " .. player:getLivestreamViewersCount() .. " WHERE `caster_id` = " .. player:getGuid())
end

local function resetAllLivestreamStatuses()
	return executeLivestreamQuery("UPDATE `active_livestream_casters` SET `livestream_status` = 0, `livestream_viewers` = 0")
end

local function setExperienceBonus(player, enabled)
	if not experienceMultiplier or experienceMultiplier <= 1.0 then
		return
	end

	if enabled then
		player:kv():scoped("livestream-system"):set("experience-bonus", true)
		player:sendTextMessage(MESSAGE_LOOK, "Experience bonus activated: +" .. bonusPercent .. "%")
	else
		player:kv():scoped("livestream-system"):remove("experience-bonus")
		player:sendTextMessage(MESSAGE_LOOK, "Experience bonus deactivated: -" .. bonusPercent .. "%")
	end
end

local talkaction = TalkAction("!livestream")

function talkaction.onSay(player, words, param)
	local minLevelToLivestream = configManager.getNumber(configKeys.LIVESTREAM_CASTER_MIN_LEVEL)
	if player:getLevel() < minLevelToLivestream then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need to be at least level " .. minLevelToLivestream .. " to use this command.")
		return false
	end

	local split = param:splitTrimmed(",")
	local command = (split[1] or "help"):lower()
	local value = split[2]
	local data = normalizeData(player:getLivestreamViewers())

	if command == "help" then
		player:popupFYI(table.concat(helpMessages, "\n"))
	elseif table.contains({ "off", "no", "disable" }, command) then
		if not data.broadcast then
			player:sendTextMessage(MESSAGE_STATUS, "You already have the live stream closed.")
			return true
		end
		data.mutes = {}
		data.broadcast = false
		updateLivestreamStatus(player, 0, 0)
		player:sendTextMessage(MESSAGE_STATUS, "Your stream is currently disabled.")
		setExperienceBonus(player, false)
		playersStreaming[player:getGuid()] = nil
	elseif table.contains({ "on", "yes", "enable" }, command) then
		if data.broadcast then
			upsertLivestreamStatus(player, data.password == "" and 1 or 3, #data.names)
			setExperienceBonus(player, data.password == "")
			playersStreaming[player:getGuid()] = true
			player:sendTextMessage(MESSAGE_STATUS, "You already have the live stream open.")
			return true
		end
		data.broadcast = true
		upsertLivestreamStatus(player, data.password == "" and 1 or 3, #data.names)
		player:sendTextMessage(MESSAGE_STATUS, "You have started live broadcast.")
		setExperienceBonus(player, data.password == "")
		playersStreaming[player:getGuid()] = true
	elseif table.contains({ "show", "count", "see" }, command) then
		if not data.broadcast then
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		elseif #data.names > 0 then
			player:sendTextMessage(MESSAGE_STATUS, "You are currently watched by " .. #data.names .. " people.")
			player:sendTextMessage(MESSAGE_STATUS, joinNames(data.names) .. ".")
		else
			player:sendTextMessage(MESSAGE_STATUS, "None is watching your stream right now.")
		end
	elseif table.contains({ "kick", "remove" }, command) then
		if not data.broadcast then
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		elseif not value then
			player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
		elseif value:lower() == "all" then
			data.kick = data.names
			player:sendTextMessage(MESSAGE_STATUS, "All players have been kicked.")
		elseif containsName(data.names, value) then
			table.insert(data.kick, value)
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " has been kicked.")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " not found.")
		end
	elseif table.contains({ "ban", "block" }, command) then
		if not data.broadcast then
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		elseif not value then
			player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
		elseif containsName(data.bans, value) then
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " is already banned.")
		elseif containsName(data.names, value) then
			table.insert(data.bans, value)
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " has been banned.")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " not found.")
		end
	elseif table.contains({ "unban", "unblock" }, command) then
		if not value then
			player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
		elseif removeNameOccurrences(data.bans, value) then
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " has been unbanned.")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " not found.")
		end
	elseif table.contains({ "bans", "banlist" }, command) then
		if #data.bans > 0 then
			player:sendTextMessage(MESSAGE_STATUS, "Currently banned spectators: " .. joinNames(data.bans) .. ".")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Your ban list is empty.")
		end
	elseif table.contains({ "mute", "squelch" }, command) then
		if not data.broadcast then
			player:sendTextMessage(MESSAGE_STATUS, "You are not streaming right now.")
		elseif not value then
			player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
		elseif containsName(data.mutes, value) then
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " is already muted.")
		elseif containsName(data.names, value) then
			table.insert(data.mutes, value)
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " has been muted.")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " not found.")
		end
	elseif table.contains({ "unmute", "unsquelch" }, command) then
		if not value then
			player:sendTextMessage(MESSAGE_STATUS, "You need to type a name.")
		elseif removeNameOccurrences(data.mutes, value) then
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " has been unmuted.")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Spectator " .. value .. " not found.")
		end
	elseif table.contains({ "mutes", "mutelist" }, command) then
		if #data.mutes > 0 then
			player:sendTextMessage(MESSAGE_STATUS, "Currently muted spectators: " .. joinNames(data.mutes) .. ".")
		else
			player:sendTextMessage(MESSAGE_STATUS, "Your mute list is empty.")
		end
	elseif table.contains({ "password", "guard" }, command) then
		if not value or value:trim() == "" or table.contains({ "off", "no", "disable" }, value:lower()) then
			data.password = ""
			player:kv():scoped("livestream-system"):remove("password")
			if data.broadcast then
				upsertLivestreamStatus(player, 1, #data.names)
			end
			player:sendTextMessage(MESSAGE_STATUS, "You have removed password for your stream.")
			setExperienceBonus(player, data.broadcast)
		else
			data.password = value:trim()
			player:kv():scoped("livestream-system"):set("password", data.password)
			if data.broadcast then
				upsertLivestreamStatus(player, 3, #data.names)
			end
			player:sendTextMessage(MESSAGE_STATUS, "You have set new password for your stream.")
			setExperienceBonus(player, false)
		end
		player:sendTextMessage(MESSAGE_STATUS, data.password ~= "" and ("Your stream is currently protected with password: " .. data.password .. ".") or "Your stream is currently not protected.")
	elseif table.contains({ "desc", "description" }, command) then
		if not value or value:trim() == "" or table.contains({ "remove", "delete" }, value:lower()) then
			data.description = ""
			player:kv():scoped("livestream-system"):remove("description")
			player:sendTextMessage(MESSAGE_STATUS, "You have removed description for your stream.")
		elseif value:len() > 50 then
			player:sendTextMessage(MESSAGE_STATUS, "Your description max length 50 characters.")
			return false
		elseif value:match("[%a%d%s%u%l]+") ~= value then
			player:sendTextMessage(MESSAGE_STATUS, "Please only A-Z 0-9.")
			return false
		else
			data.description = value
			player:kv():scoped("livestream-system"):set("description", value)
			player:sendTextMessage(MESSAGE_STATUS, "Livestream description was set to: " .. value .. ".")
		end
	elseif table.contains({ "status", "info" }, command) then
		player:sendTextMessage(MESSAGE_STATUS, "Your stream is currently " .. (data.broadcast and "enabled" or "disabled") .. ".")
	else
		player:popupFYI(table.concat(helpMessages, "\n"))
	end

	player:setLivestreamViewers(data)
	return true
end

talkaction:separator(" ")
talkaction:groupType("normal")
talkaction:register()

local logoutEvent = CreatureEvent("LivestreamLogout")

function logoutEvent.onLogout(player)
	updateLivestreamStatus(player, 0, 0)
	playersStreaming[player:getGuid()] = nil
	return true
end

logoutEvent:register()

local loginEvent = CreatureEvent("LivestreamLogin")

function loginEvent.onLogin(player)
	player:registerEvent("LivestreamLogout")
	updateLivestreamStatus(player, 0, 0)
	player:kv():scoped("livestream-system"):remove("experience-bonus")
	return true
end

loginEvent:register()

local thinkEvent = GlobalEvent("LivestreamThink")

function thinkEvent.onThink(interval)
	for playerGuid in pairs(playersStreaming) do
		local player = Player(playerGuid)
		if player then
			updateLivestreamViewerCount(player)
		else
			playersStreaming[playerGuid] = nil
		end
	end
	return true
end

thinkEvent:interval(10000)
thinkEvent:register()

local startupEvent = GlobalEvent("LivestreamOnStartup")

function startupEvent.onStartup()
	resetAllLivestreamStatuses()
	return true
end

startupEvent:register()

local gainExperience = EventCallback("LivestreamSystemGainExperience")

function gainExperience.playerOnGainExperience(player, target, exp, rawExp)
	if experienceMultiplier and experienceMultiplier > 1.0 and player:kv():scoped("livestream-system"):get("experience-bonus") then
		exp = math.floor(exp * experienceMultiplier + 0.5)
	end

	return exp
end

gainExperience:register()
