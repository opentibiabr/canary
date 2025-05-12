local unban = TalkAction("/unban")

function unban.onSay(player, words, param)
    -- create log
    logCommand(player, words, param)

    if param == "" then
        player:sendCancelMessage("Command param required.")
        return true
    end

    -- Chama a função C++ centralizada
    local result = Game.unbanPlayer(param, player:getGuid())
    if result then
        local text = param .. " has been unbanned."
        player:sendTextMessage(MESSAGE_ADMINISTRATOR, text)
        Webhook.sendMessage("Player Unbanned", text .. " (by: " .. player:getName() .. ")", WEBHOOK_COLOR_YELLOW, announcementChannels["serverAnnouncements"])
    else
        player:sendCancelMessage("Failed to unban player. Maybe not banned or player not found.")
    end
    return true
end

unban:separator(" ")
unban:groupType("gamemaster")
unban:register()
