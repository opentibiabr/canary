local mcCheck = TalkAction("/mc")

function mcCheck.onSay(player, words, param)
    -- create log
    logCommand(player, words, param)

    player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Multiclient Check List:")

    local ipList = {}
    local players = Game.getPlayers()

    for i = 1, #players do
        local tmpPlayer = players[i]
        local ipString = tmpPlayer:getIpString()

        local key
        if ipString and ipString ~= "" then
            key = ipString
        else
            key = tmpPlayer:getIp()
        end

        if key and key ~= "" and key ~= 0 then
            local list = ipList[key]
            if not list then
                list = {}
                ipList[key] = list
            end
            list[#list + 1] = tmpPlayer
        end
    end

    for _, list in pairs(ipList) do
        local listLength = #list
        if listLength > 1 then
            local tmpPlayer = list[1]
            local message = ("%s: %s [%d]"):format(
                Game.convertIpToString(tmpPlayer:getIp(), tmpPlayer:getIpString()),
                tmpPlayer:getName(),
                tmpPlayer:getLevel()
            )

            for i = 2, listLength do
                tmpPlayer = list[i]
                message = ("%s, %s [%d]"):format(
                    message,
                    tmpPlayer:getName(),
                    tmpPlayer:getLevel()
                )
            end

            player:sendTextMessage(MESSAGE_ADMINISTRATOR, message .. ".")
        end
    end

    return true
end

mcCheck:separator(" ")
mcCheck:groupType("gamemaster")
mcCheck:register()
