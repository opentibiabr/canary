-- Hideout Exit Script
-- This script handles the exit portal in hideouts

local exitPortal = MoveEvent()

function exitPortal.onStepIn(creature, item, position, fromPosition)
    -- Check if the creature is a player
    if not creature:isPlayer() then
        return true
    end
    
    local player = creature:getPlayer()
    
    -- Check if player is in an instance
    if not isPlayerInInstance(player:getId()) then
        return true
    end
    
    -- Teleport player out of the instance
    local success = teleportFromPlayerInstance(player:getId())
    if not success then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to exit hideout.")
        player:teleportTo(fromPosition, true)
        return false
    end
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have left the hideout.")
    return true
end

-- Register the move event for the exit portal
exitPortal:type("stepin")
exitPortal:id(1387) -- Magic Forcefield (Exit Portal)
exitPortal:register()