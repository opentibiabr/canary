-- Hideout Kick Command Script
-- This script handles the !kick command to remove players from your hideout

local kickCommand = TalkAction("!kick")

function kickCommand.onSay(player, words, param)
    -- Check if player has a hideout
    local hideoutId = getPlayerHideoutId(player:getId())
    if hideoutId == 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have a hideout.")
        return false
    end
    
    -- Check if player is in their hideout
    local currentInstanceId = getPlayerInstanceId(player:getId())
    if currentInstanceId ~= hideoutId then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must be in your hideout to kick players.")
        return false
    end
    
    -- Check if a target player was specified
    if param == "" then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Please specify a player to kick. Usage: !kick <player name>")
        return false
    end
    
    -- Find the target player
    local targetPlayer = Player(param)
    if not targetPlayer then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player not found.")
        return false
    end
    
    -- Check if the target player is in the hideout
    local targetInstanceId = getPlayerInstanceId(targetPlayer:getId())
    if targetInstanceId ~= hideoutId then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "That player is not in your hideout.")
        return false
    end
    
    -- Check if the target player is the owner
    if targetPlayer:getId() == player:getId() then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot kick yourself from your own hideout.")
        return false
    end
    
    -- Teleport the target player out of the hideout
    local success = teleportFromPlayerInstance(targetPlayer:getId())
    if not success then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to kick player from hideout.")
        return false
    end
    
    -- Notify both players
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have kicked " .. targetPlayer:getName() .. " from your hideout.")
    targetPlayer:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have been kicked from " .. player:getName() .. "'s hideout.")
    
    return true
end

kickCommand:register()