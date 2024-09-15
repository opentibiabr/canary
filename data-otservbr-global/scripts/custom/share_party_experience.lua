local party = TalkAction("!shareparty")

function party.onSay(player, words, param)
     local party = player:getParty()
    if not party then
        player:sendCancelMessage("You are not part of a party.")
        return false
    end
    
    if party:getLeader() ~= player then
        player:sendCancelMessage("You are not the leader of the party.")
        return false
    end
            
    if party:isSharedExperienceActive() then
            player:sendCancelMessage("Party share is already activated.")
        return false
    end
    
    party:setSharedExperience(true)
    
    return false
end
party:groupType("normal")
party:register()