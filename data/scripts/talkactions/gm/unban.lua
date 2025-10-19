local unban = TalkAction("/unban")

function unban.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

        local resultId = db.storeQuery("SELECT `account_id`, INET6_NTOA(`lastip`) AS `lastip` FROM `players` WHERE `name` = " .. db.escapeString(param))
	if resultId == false then
		return true
	end

        db.asyncQuery("DELETE FROM `account_bans` WHERE `account_id` = " .. Result.getNumber(resultId, "account_id"))
        local lastIp = Result.getString(resultId, "lastip")
        if lastIp and lastIp ~= "" then
                db.asyncQuery("DELETE FROM `ip_bans` WHERE `ip` = INET6_ATON(" .. db.escapeString(lastIp) .. ")")
        end
	Result.free(resultId)
	local text = param .. " has been unbanned."
	player:sendTextMessage(MESSAGE_ADMINISTRATOR, text)
	Webhook.sendMessage("Player Unbanned", text .. " (by: " .. player:getName() .. ")", WEBHOOK_COLOR_YELLOW, announcementChannels["serverAnnouncements"])
	return true
end

unban:separator(" ")
unban:groupType("gamemaster")
unban:register()
