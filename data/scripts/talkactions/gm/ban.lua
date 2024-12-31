local ban = TalkAction("/ban")

function ban.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local params = param:split(",")
	if #params < 3 then
		player:sendCancelMessage("Command requires 3 parameters: /ban <player name>, <duration in days>, <reason>")
		return true
	end

	local playerName = params[1]:trim()
	local banDuration = tonumber(params[2]:trim())
	local banReason = params[3]:trim()

	if not banDuration or banDuration <= 0 then
		player:sendCancelMessage("Ban duration must be a positive number.")
		return true
	end

	local accountId = Game.getPlayerAccountId(playerName)
	if accountId == 0 then
		return true
	end

	local resultId = db.storeQuery("SELECT 1 FROM `account_bans` WHERE `account_id` = " .. accountId)
	if resultId then
		result.free(resultId)
		return true
	end

	local currentTime = os.time()
	local expirationTime = currentTime + (banDuration * 24 * 60 * 60)
	db.query(string.format("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (%d, %s, %d, %d, %d)", accountId, db.escapeString(banReason), currentTime, expirationTime, player:getGuid()))

	local target = Player(playerName)
	if target then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, string.format("%s has been banned for %d days.", target:getName(), banDuration))
		target:remove()
		Webhook.sendMessage("Player Banned", string.format("%s has been banned for %d days. Reason: %s (by: %s)", target:getName(), banDuration, banReason, player:getName()), WEBHOOK_COLOR_YELLOW, announcementChannels["serverAnnouncements"])
	else
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, string.format("%s has been banned for %d days.", playerName, banDuration))
	end
	return true
end

ban:separator(" ")
ban:groupType("gamemaster")
ban:register()
