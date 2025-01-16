local pzTime = TalkAction("!pz")

function pzTime.onSay(player, words, param)
    local battleTime = player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT)
    if not battleTime then 
        player:sendCancelMessage("You don't have PZ.")
    else
        local timeLeft = (battleTime:getEndTime() - os.time() * 1000) / 1000
        local message
        if timeLeft > 60 then
            local minutes = math.floor(timeLeft / 60)
            local seconds = timeLeft % 60
            message = string.format("You have to wait %d minutes and %d seconds for PZ.", minutes, seconds)
        else
            message = string.format("You have to wait %d seconds for PZ.", timeLeft)
        end
        player:sendTextMessage(MESSAGE_FAILURE, message)
    end
    return true
end

pzTime:groupType("normal")
pzTime:separator(" ")
pzTime:register()
