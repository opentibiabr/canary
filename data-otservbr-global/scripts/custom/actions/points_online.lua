local config = {
    storage = 30070,
    tokenItemId = 19082,
    tokensPerHour = 10,
    tokensPerHourVIP = 20,
    checkDuplicateIps = true
}

local onlineTokensEvent = GlobalEvent("GainTokenPerHour")

function onlineTokensEvent.onThink(interval)
    local players = Game.getPlayers()
    if #players == 0 then
        return true
    end

    local checkIp = {}
    for _, player in pairs(players) do
        local ip = player:getIp()
        if ip ~= 0 and (not config.checkDuplicateIps or not checkIp[ip]) then
            checkIp[ip] = false
            local seconds = math.max(0, player:getStorageValue(config.storage))
            if seconds >= 3600 then
                player:setStorageValue(config.storage, 0)
                    if player:isVip() then
                        player:addItem(config.tokenItemId, config.tokensPerHourVIP)
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "(VIP) You received 20 Online Token for being online for one hour.")
                    else
                        player:addItem(config.tokenItemId, config.tokensPerHour)
			            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received 10 Online Token for being online for one hour.")
                    end
                return true
            end
            player:setStorageValue(config.storage, seconds +math.ceil(interval/1000))
        end
    end
    return true
end

onlineTokensEvent:interval(10000)
onlineTokensEvent:register()