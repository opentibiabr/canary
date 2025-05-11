-- Hideout Command Script
-- This script handles the !hideout command to teleport to the player's hideout

local hideoutCommand = TalkAction("!hideout")

function hideoutCommand.onSay(player, words, param)
    -- Check if player already has a hideout instance
    local hideoutId = getPlayerHideoutId(player:getId())
    
    if hideoutId == 0 then
        -- Create a new hideout instance for the player
        hideoutId = createPlayerHideout(player:getId())
        if hideoutId == 0 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to create hideout.")
            return false
        end
        
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your hideout has been created.")
    end
    
    -- Teleport to hideout
    local success = teleportToPlayerInstance(player:getId(), hideoutId)
    if not success then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to teleport to hideout.")
        return false
    end
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to your hideout! Use the portal device to create hunting instances.")
    return true
end

-- Function to get a player's hideout instance ID
function getPlayerHideoutId(playerId)
    -- Check if the player has a hideout instance in the global table
    if not GlobalHideouts then
        GlobalHideouts = {}
    end
    
    return GlobalHideouts[playerId] or 0
end

-- Function to create a hideout instance for a player
function createPlayerHideout(playerId)
    -- Get the player
    local player = Player(playerId)
    if not player then
        return 0
    end
    
    -- Create the hideout instance
    local instanceId = createPlayerInstance(playerId, InstanceMaps["hideout"].mapFile, 
                                          {x = 1000, y = 1000, z = 7}, player:getPosition(), false)
    
    if instanceId == 0 then
        return 0
    end
    
    -- Store the hideout instance ID in the global table
    if not GlobalHideouts then
        GlobalHideouts = {}
    end
    
    GlobalHideouts[playerId] = instanceId
    
    return instanceId
end

hideoutCommand:register()