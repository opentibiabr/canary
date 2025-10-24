local ipBanDays = 7
local ipBan = TalkAction("/ipban")

function ipBan.onSay(player, words, param)
    -- create log
    logCommand(player, words, param)

    if param == "" then
        player:sendCancelMessage("Command param required.")
        return true
    end

    local resultId = db.storeQuery(
        "SELECT `name`, `lastip` FROM `players` WHERE `name` = " .. db.escapeString(param)
    )

    if not resultId then
        return true
    end

    local targetName = Result.getString(resultId, "name")
    local targetIp = Result.getString(resultId, "lastip")
    Result.free(resultId)

    local targetPlayer = Player(param)
    if targetPlayer then
        targetIp = targetPlayer:getIpString()
        targetPlayer:remove()
    end

    if not targetIp or targetIp == "" then
        return true
    end

    resultId = db.storeQuery(
        "SELECT 1 FROM `ip_bans` WHERE `ip` = " .. db.escapeString(targetIp)
    )

    if resultId then
        player:sendTextMessage(
            MESSAGE_ADMINISTRATOR,
            targetName .. " is already IP banned."
        )
        Result.free(resultId)
        return true
    end

    local timeNow = os.time()
    db.query(string.format(
        "INSERT INTO `ip_bans` (`ip`, `reason`, `banned_at`, `expires_at`, `banned_by`) " ..
        "VALUES (%s, '', %d, %d, %d)",
        db.escapeString(targetIp),
        timeNow,
        timeNow + (ipBanDays * 86400),
        player:getGuid()
    ))

    player:sendTextMessage(
        MESSAGE_ADMINISTRATOR,
        targetName .. " has been IP banned."
    )

    return true
end

ipBan:separator(" ")
ipBan:groupType("god")
ipBan:register()
