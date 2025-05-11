-- Hunting Instance Command
-- This script handles the !hunt command to create a hunting instance

local huntCommand = TalkAction("!hunt")

function huntCommand.onSay(player, words, param)
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
    
    -- Create a personal hunting instance
    return createHuntingInstance(player, mapType, false)
end

huntCommand:register()