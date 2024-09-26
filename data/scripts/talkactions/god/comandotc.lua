local tibiaCoins = TalkAction("/tc")

function tibiaCoins.onSay(player, words, param)   

    if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end
    local usage = "/tc PLAYER NAME,TC AMOUNT"
    if param == "" then
        player:sendCancelMessage("Command param required. Usage: ".. usage)
        return false
    end

    local split = param:split(",")
    if not split[2] then
        player:sendCancelMessage("Insufficient parameters. Usage: ".. usage)
        return false
    end

    local target = Player(split[1])
    if not target then
        player:sendCancelMessage("A player with that name is not online.")
        return false
    end
    --trim left
    split[2] = split[2]:gsub("^%s*(.-)$", "%1")
    
    player:sendCancelMessage("Added " .. split[2] .. " tibia coins to the character '" .. target:getName() .. "'.")
    target:sendCancelMessage("Received " .. split[2] .. " tibia coins!")
    target:addTransferableCoins(tonumber(split[2]))
    target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)


end

tibiaCoins:separator(" ")
tibiaCoins:groupType("god")
tibiaCoins:register()