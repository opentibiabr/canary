local ban = TalkAction("/ban")

function ban.onSay(player, words, param)
    -- Cria um log
    logCommand(player, words, param)

    if param == "" then
        player:sendCancelMessage("Command param required.")
        return true
    end

    -- Dividindo os parâmetros
    local separatorPos1 = param:find(",") -- Encontra a primeira vírgula
    if not separatorPos1 then
        player:sendCancelMessage("Invalid command format. Use: /ban playername, reason, days.")
        return true
    end

    local name = param:sub(0, separatorPos1 - 1) -- Nome do jogador
    local reasonAndDays = string.trim(param:sub(separatorPos1 + 1)) -- O restante (razão e dias)
    
    -- Dividindo razão e dias
    local separatorPos2 = reasonAndDays:find(",") -- Encontra a segunda vírgula
    if not separatorPos2 then
        player:sendCancelMessage("Invalid command format. Use: /ban playername, reason, days.")
        return true
    end

    local reason = reasonAndDays:sub(0, separatorPos2 - 1) -- Razão do banimento
    local daysString = string.trim(reasonAndDays:sub(separatorPos2 + 1)) -- Dias como string
    local banDays = tonumber(daysString) -- Converte para número

    if not banDays or banDays <= 0 then
        player:sendCancelMessage("Invalid number of days.")
        return true
    end

    local accountId = getAccountNumberByPlayerName(name)
    if accountId == 0 then
        player:sendCancelMessage("Player not found.")
        return true
    end

    -- Verifica se o jogador já está banido
    local resultId = db.storeQuery("SELECT 1 FROM `account_bans` WHERE `account_id` = " .. accountId)
    if resultId ~= false then
        Result.free(resultId)
        player:sendCancelMessage("Player is already banned.")
        return true
    end

	if banDays > 350000 then
		player:sendCancelMessage("Ban duration cannot exceed 350000 days.")
		return true
	end

    local timeNow = os.time()
    local expiresAt = timeNow + (banDays * 86400) -- Calcula a data de expiração

    -- Insere o registro de banimento no banco de dados
    db.query("INSERT INTO `account_bans` (`account_id`, `reason`, `banned_at`, `expires_at`, `banned_by`) VALUES (" .. accountId .. ", " .. db.escapeString(reason) .. ", " .. timeNow .. ", " .. expiresAt .. ", " .. player:getGuid() .. ")")

    local target = Player(name)
    if target then
        local text = target:getName() .. " has been banned for " .. banDays .. " days."
        player:sendTextMessage(MESSAGE_ADMINISTRATOR, text)
        Webhook.sendMessage("Player Banned", text .. " Reason: " .. reason .. ". (by: " .. player:getName() .. ")", WEBHOOK_COLOR_YELLOW, announcementChannels["serverAnnouncements"])
        target:remove()
		local banGlobalMessage = "Player ".. text .. " (by: ".. player:getName() .."), Reason: ".. reason
		logger.info(banGlobalMessage)
		Broadcast(banGlobalMessage)
    else
        player:sendTextMessage(MESSAGE_ADMINISTRATOR, name .. " has been banned for " .. banDays .. " days.")
    end
end

ban:separator(" ")
ban:groupType("gamemaster")
ban:register()
