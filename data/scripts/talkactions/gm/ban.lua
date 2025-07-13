local ban = TalkAction("/ban")

function ban.onSay(player, words, param)
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required. Use: /ban playername, days [, reason].")
		return true
	end

	local name, daysStr, reason = param:match("^%s*([^,]+)%s*,%s*([^,]+)%s*,?%s*(.*)$")
	if not name or not daysStr then
		player:sendCancelMessage("Invalid command format. Use: /ban playername, days [, reason].")
		return true
	end

	local banDays = tonumber(daysStr)
	if not banDays or banDays <= 0 then
		player:sendCancelMessage("Invalid number of days.")
		return true
	end

	if banDays > 350000 then
		player:sendCancelMessage("Ban duration cannot exceed 350000 days.")
		return true
	end

	local accountId = Game.getPlayerAccountId(name)
	if accountId == 0 then
		player:sendCancelMessage("Player not found.")
		return true
	end

	local timeNow = os.time()
	local expiresAt = timeNow + (banDays * 86400)

	local resultId = db.storeQuery("SELECT `expires_at` FROM `account_bans` WHERE `account_id` = " .. accountId)
	if resultId then
		local currentExpires = result.getNumber(resultId, "expires_at")
		Result.free(resultId)
		if expiresAt > currentExpires then
			db.query("UPDATE `account_bans` SET `reason` = " .. db.escapeString(reason or "") .. ", `expires_at` = " .. expiresAt .. ", `banned_by` = " .. player:getGuid() .. " WHERE `account_id` = " .. accountId)
			player:sendTextMessage(MESSAGE_ADMINISTRATOR, name .. "'s ban has been extended to " .. banDays .. " days.")
		else
			player:sendCancelMessage("Player is already banned for longer or equal duration.")
		end
		return true
	else
		db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" .. accountId .. ", " .. db.escapeString(reason or "") .. ", " .. timeNow .. ", " .. expiresAt .. ", " .. player:getGuid() .. ")")
	end

	local target = Player(name)
	local text = name .. " has been banned for " .. banDays .. " days."
	if target then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, text)
		Webhook.sendMessage("Player Banned", text .. " Reason: " .. (reason or "Not provided") .. ". (by: " .. player:getName() .. ")", WEBHOOK_COLOR_YELLOW, announcementChannels["serverAnnouncements"])
		target:remove()
		local banGlobalMessage = "Player " .. text .. " (by: " .. player:getName() .. "), Reason: " .. (reason or "Not provided")
		logger.info(banGlobalMessage)
		Broadcast(banGlobalMessage)
	else
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, text)
	end

	return true
end

ban:separator(" ")
ban:groupType("gamemaster")
ban:register()
