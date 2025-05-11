-- Hunting Party Command
-- This script handles the !joinparty command to join a party member's hunting instance

local joinPartyCommand = TalkAction("!joinparty")

function joinPartyCommand.onSay(player, words, param)
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
    
    -- Try to join a party member's instance
    return joinPartyInstance(player)
end

joinPartyCommand:register()