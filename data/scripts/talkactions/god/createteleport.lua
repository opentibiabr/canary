local createTP = TalkAction("/tp")

function createTP.onSay(player, words, param)
    if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
        return true
    end
    logCommand(player, words, param)
    if param == "" then
        player:sendCancelMessage("Command param required.")
        return false
    end
    param = param:split(',')
    if param[3] then
        local position = player:getPosition()
        position:getNextPosition(player:getDirection())
        local tp = Game.createItem(35502,1,position)
        if tp then
            tp:setDestination(Position(param[1],param[2], param[3]))
        end
    else
        player:sendCancelMessage("Command example /tp 32420, 32217, 7")
    end
    return false
end

createTP:separator(" ")
createTP:groupType("god")
createTP:register()
