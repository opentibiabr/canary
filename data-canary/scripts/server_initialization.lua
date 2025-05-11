-- Server Initialization Script
-- This script is loaded when the server starts and initializes various systems

-- Load instance scripts
dofile('data-canary/scripts/instances/instance_manager.lua')
dofile('data-canary/scripts/instances/hunting_instance_command.lua')
dofile('data-canary/scripts/instances/hunting_party_command.lua')
dofile('data-canary/scripts/instances/hunting_party_instance_command.lua')

-- Load hideout scripts
dofile('data-canary/scripts/instances/hideout_command.lua')
dofile('data-canary/scripts/instances/hideout_invite_command.lua')
dofile('data-canary/scripts/instances/hideout_exit.lua')
dofile('data-canary/scripts/instances/hideout_kick_command.lua')

-- Load portal device script
dofile('data-canary/scripts/actions/portal_device.lua')

-- Initialize the instance system
print("Initializing instance system...")
-- Schedule instance cleanup every hour (3600 seconds)
addEvent(function()
    cleanupInstances()
    addEvent(cleanupInstances, 3600 * 1000)
end, 3600 * 1000)

-- Initialize global tables
GlobalHideouts = {}
GlobalInstanceData = {}

print("Server initialization complete!")