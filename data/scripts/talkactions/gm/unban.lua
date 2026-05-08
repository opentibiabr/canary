local unban = TalkAction("/unban")

local function getLegacyIpAddressExpression(columnName)
	return "CONCAT((`" .. columnName .. "` & 255), '.', ((`" .. columnName .. "` >> 8) & 255), '.', ((`" .. columnName .. "` >> 16) & 255), '.', ((`" .. columnName .. "` >> 24) & 255))"
end

function unban.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local query = "SELECT `account_id`, `lastip`, CASE WHEN `lastip_address` != '' THEN `lastip_address` WHEN `lastip` != 0 THEN " .. getLegacyIpAddressExpression("lastip") .. " ELSE '' END AS `lastip_address` FROM `players` WHERE `name` = " .. db.escapeString(param)
	local resultId = db.storeQuery(query)
	if resultId == false then
		return true
	end

	local accountId = Result.getNumber(resultId, "account_id")
	local lastIp = Result.getNumber(resultId, "lastip")
	local lastIpAddress = Result.getString(resultId, "lastip_address")
	Result.free(resultId)

	db.asyncQuery("DELETE FROM `account_bans` WHERE `account_id` = " .. accountId)
	if lastIpAddress ~= "" then
		db.asyncQuery("DELETE FROM `ip_bans` WHERE `ip_address` = " .. db.escapeString(lastIpAddress))
	elseif lastIp ~= 0 then
		db.asyncQuery("DELETE FROM `ip_bans` WHERE `ip` = " .. lastIp)
	end

	local text = param .. " has been unbanned."
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, text)
	Webhook.sendMessage("Player Unbanned", text .. " (by: " .. player:getName() .. ")", WEBHOOK_COLOR_YELLOW, announcementChannels["serverAnnouncements"])
	return true
end

unban:separator(" ")
unban:groupType("gamemaster")
unban:register()
