-- Hunting Party Instance Command
-- This script handles the !partyinstance command to create a party hunting instance

local partyInstanceCommand = TalkAction("!partyinstance")

function partyInstanceCommand.onSay(player, words, param)
    -- Check if player is in a party
    local party = player:getParty()
    if not party then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not in a party.")
        return false
    end
    
    -- Check if player is already in an instance
    if isPlayerInInstance(player:getId()) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are already in a hunting instance. Type !leave to exit first.")
        return false
    end
    
    -- Parse the map type parameter
    local mapType = param
    if mapType == "" then
        mapType = "beginner" -- Default map type
    end
    
    -- Create a party hunting instance
    return createHuntingInstance(player, mapType, true)
end

partyInstanceCommand:register()