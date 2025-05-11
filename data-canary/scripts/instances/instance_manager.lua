-- Instance Manager Script
-- This script provides functions to create and manage player instances

-- Configuration
local config = {
    -- Default instance map template
    defaultMapTemplate = "hunting_grounds",
    
    -- Default instance entry position
    defaultEntryPosition = Position(1000, 1000, 7),
    
    -- Instance cleanup time in seconds (1 hour)
    instanceCleanupTime = 3600,
    
    -- Available hunting maps
    huntingMaps = {
        ["beginner"] = {
            mapName = "beginner_hunting_grounds",
            entryPosition = Position(1000, 1000, 7),
            minLevel = 1,
            maxLevel = 50
        },
        ["intermediate"] = {
            mapName = "intermediate_hunting_grounds",
            entryPosition = Position(1000, 1000, 7),
            minLevel = 51,
            maxLevel = 100
        },
        ["advanced"] = {
            mapName = "advanced_hunting_grounds",
            entryPosition = Position(1000, 1000, 7),
            minLevel = 101,
            maxLevel = 200
        },
        ["expert"] = {
            mapName = "expert_hunting_grounds",
            entryPosition = Position(1000, 1000, 7),
            minLevel = 201,
            maxLevel = 999
        }
    }
}

-- Create a hunting instance for a player or party
function createHuntingInstance(player, mapType, isPartyInstance)
    if not player then
        return false
    end
    
    -- Store the player's current position as the exit position
    local exitPosition = player:getPosition()
    
    -- Get the map configuration based on the map type
    local mapConfig = config.huntingMaps[mapType]
    if not mapConfig then
        -- Use default map if the specified type doesn't exist
        mapConfig = config.huntingMaps["beginner"]
    end
    
    -- Check if player meets the level requirements
    local playerLevel = player:getLevel()
    if playerLevel < mapConfig.minLevel or playerLevel > mapConfig.maxLevel then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't meet the level requirements for this hunting ground.")
        return false
    end
    
    -- Check if player is in a party and this is a party instance
    if isPartyInstance then
        local party = player:getParty()
        if party then
            -- Check if any party member is already in an instance
            local partyMembers = party:getMembers()
            table.insert(partyMembers, party:getLeader()) -- Add leader to members list
            
            for _, member in ipairs(partyMembers) do
                local memberInstanceId = getPlayerInstanceId(member:getId())
                if memberInstanceId > 0 then
                    -- A party member is already in an instance, teleport to that instance
                    local success = teleportToPlayerInstance(player:getId(), memberInstanceId)
                    if success then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have joined your party member's hunting instance.")
                        return true
                    end
                end
            end
            
            -- No party member is in an instance, create a new one
            local instanceId = createPlayerInstance(player:getId(), mapConfig.mapName, mapConfig.entryPosition, exitPosition, true)
            if not instanceId then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to create hunting instance.")
                return false
            end
            
            -- Teleport the player to the instance
            local success = teleportToPlayerInstance(player:getId(), instanceId)
            if not success then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to teleport to hunting instance.")
                return false
            end
            
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to your party's private hunting instance! Type !leave to return.")
            
            -- Notify party members that an instance has been created
            for _, member in ipairs(partyMembers) do
                if member:getId() ~= player:getId() then
                    member:sendTextMessage(MESSAGE_EVENT_ADVANCE, player:getName() .. " has created a party hunting instance. Type !joinparty to join.")
                end
            end
            
            return true
        else
            -- Player is not in a party, create a personal instance
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not in a party. Creating a personal instance instead.")
            isPartyInstance = false
        end
    end
    
    -- Create a personal instance
    local instanceId = createPlayerInstance(player:getId(), mapConfig.mapName, mapConfig.entryPosition, exitPosition, false)
    if not instanceId then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to create hunting instance.")
        return false
    end
    
    -- Teleport the player to the instance
    local success = teleportToPlayerInstance(player:getId(), instanceId)
    if not success then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to teleport to hunting instance.")
        return false
    end
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Welcome to your private hunting instance! Type !leave to return.")
    return true
end

-- Teleport a player out of their hunting instance
function leaveHuntingInstance(player)
    if not player then
        return false
    end
    
    -- Check if player is in an instance
    if not isPlayerInInstance(player:getId()) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not in a hunting instance.")
        return false
    end
    
    -- Teleport the player out of the instance
    local success = teleportFromPlayerInstance(player:getId())
    if not success then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to leave hunting instance.")
        return false
    end
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have left your hunting instance.")
    return true
end

-- Cleanup expired instances
function cleanupInstances()
    -- This function should be called periodically to clean up expired instances
    -- For example, every hour
    print("Cleaning up expired instances...")
    -- Call the C++ function to clean up instances
    -- The parameter is the maximum age in seconds
    -- Instances older than this will be removed
    -- 3600 seconds = 1 hour
    cleanupPlayerInstances(config.instanceCleanupTime)
end

-- Join a party member's instance
function joinPartyInstance(player)
    if not player then
        return false
    end
    
    -- Check if player is in a party
    local party = player:getParty()
    if not party then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not in a party.")
        return false
    end
    
    -- Get party members
    local partyMembers = party:getMembers()
    table.insert(partyMembers, party:getLeader()) -- Add leader to members list
    
    -- Check if any party member is in an instance
    for _, member in ipairs(partyMembers) do
        if member:getId() ~= player:getId() then
            local memberInstanceId = getPlayerInstanceId(member:getId())
            if memberInstanceId > 0 then
                -- A party member is in an instance, teleport to that instance
                local success = teleportToPlayerInstance(player:getId(), memberInstanceId)
                if success then
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have joined " .. member:getName() .. "'s hunting instance.")
                    return true
                end
            end
        end
    end
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No party members are in a hunting instance.")
    return false
end