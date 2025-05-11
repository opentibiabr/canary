-- Instance Configuration
-- This file contains the configuration for the instance system

-- Register the instance maps
-- These maps will be loaded when the server starts
-- The maps should be placed in the data-canary/world/custom directory
-- The maps should be in the .xml format

-- Available instance maps
InstanceMaps = {
    -- Player hideout
    ["hideout"] = {
        mapFile = "data-canary/world/custom/hideout.xml",
        description = "Personal Hideout",
        maxPlayers = 10, -- Allow party members to visit
        timeLimit = 0, -- No time limit for hideouts
        cooldown = 0, -- No cooldown for hideouts
        isHideout = true -- Mark as a hideout
    },
    
    -- Hunting grounds
    ["hunting_grounds"] = {
        mapFile = "data-canary/world/custom/hunting_grounds.xml",
        description = "Basic hunting ground instance",
        maxPlayers = 10, -- Increased for party support
        timeLimit = 3600, -- 1 hour in seconds
        cooldown = 300, -- 5 minutes in seconds
        portalLimit = 6 -- Maximum number of portals (Path of Exile style)
    },
    
    -- Beginner hunting grounds
    ["beginner"] = {
        mapFile = "data-canary/world/custom/hunting_grounds.xml", -- Using the same map for now
        description = "Beginner hunting ground instance",
        maxPlayers = 10,
        timeLimit = 3600,
        cooldown = 300,
        minLevel = 1,
        maxLevel = 50,
        portalLimit = 6
    },
    
    -- Intermediate hunting grounds
    ["intermediate"] = {
        mapFile = "data-canary/world/custom/hunting_grounds.xml", -- Using the same map for now
        description = "Intermediate hunting ground instance",
        maxPlayers = 10,
        timeLimit = 3600,
        cooldown = 300,
        minLevel = 51,
        maxLevel = 100,
        portalLimit = 6
    },
    
    -- Advanced hunting grounds
    ["advanced"] = {
        mapFile = "data-canary/world/custom/hunting_grounds.xml", -- Using the same map for now
        description = "Advanced hunting ground instance",
        maxPlayers = 10,
        timeLimit = 3600,
        cooldown = 300,
        minLevel = 101,
        maxLevel = 200,
        portalLimit = 6
    },
    
    -- Expert hunting grounds
    ["expert"] = {
        mapFile = "data-canary/world/custom/hunting_grounds.xml", -- Using the same map for now
        description = "Expert hunting ground instance",
        maxPlayers = 10,
        timeLimit = 3600,
        cooldown = 300,
        minLevel = 201,
        maxLevel = 999,
        portalLimit = 6
    }
}

-- Instance settings
InstanceSettings = {
    -- Maximum age of instances in seconds (1 hour)
    maxAge = 3600,
    
    -- Maximum number of instances per player
    maxInstancesPerPlayer = 1,
    
    -- Maximum number of players per instance
    maxPlayersPerInstance = 10,
    
    -- Whether to allow party members to join instances
    allowPartyMembers = true,
    
    -- Whether to allow guild members to join instances
    allowGuildMembers = false
}

-- Load the instance scripts
dofile('data-canary/scripts/instances/instance_manager.lua')