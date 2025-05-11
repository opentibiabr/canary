-- Portal Device Script
-- This script handles the portal device that creates portals to hunting instances

local portalDevice = Action()

-- Portal device item ID (you may need to change this to an actual item ID in your server)
local PORTAL_DEVICE_ID = 2358 -- Example item ID (Magic Crystal Ball)

-- Portal item ID (you may need to change this to an actual item ID in your server)
local PORTAL_ITEM_ID = 1387 -- Example item ID (Magic Forcefield)

-- Maximum number of portals per instance
local MAX_PORTALS = 6

-- Portal positions relative to the device
local PORTAL_POSITIONS = {
    {x = -1, y = -1}, -- Top left
    {x = 0, y = -1},  -- Top
    {x = 1, y = -1},  -- Top right
    {x = -1, y = 1},  -- Bottom left
    {x = 0, y = 1},   -- Bottom
    {x = 1, y = 1}    -- Bottom right
}

-- Function to create portals around the device
function createPortals(player, devicePosition, instanceId, mapType)
    -- Get the instance data
    local instance = getInstanceById(instanceId)
    if not instance then
        return false
    end
    
    -- Check if portals already exist for this instance
    if instance.portals and #instance.portals > 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Portals for this instance already exist.")
        return false
    end
    
    -- Create portals
    local portals = {}
    for i = 1, MAX_PORTALS do
        local portalPos = Position(
            devicePosition.x + PORTAL_POSITIONS[i].x,
            devicePosition.y + PORTAL_POSITIONS[i].y,
            devicePosition.z
        )
        
        -- Check if position is walkable
        if not Tile(portalPos):isWalkable() then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Not enough space to create portals.")
            
            -- Remove any portals already created
            for _, portal in ipairs(portals) do
                portal:remove()
            end
            
            return false
        end
        
        -- Create portal item
        local portal = Game.createItem(PORTAL_ITEM_ID, 1, portalPos)
        if portal then
            portal:setAttribute(ITEM_ATTRIBUTE_UNIQUEID, instanceId * 100 + i) -- Unique ID for the portal
            table.insert(portals, portal)
        end
    end
    
    -- Store portals in instance data
    instance.portals = portals
    instance.remainingPortals = MAX_PORTALS
    
    -- Update instance data
    updateInstanceData(instanceId, instance)
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have created " .. MAX_PORTALS .. " portals to your hunting instance.")
    
    -- Notify party members if this is a party instance
    if instance.isPartyInstance then
        local party = player:getParty()
        if party then
            local partyMembers = party:getMembers()
            table.insert(partyMembers, party:getLeader()) -- Add leader to members list
            
            for _, member in ipairs(partyMembers) do
                if member:getId() ~= player:getId() then
                    member:sendTextMessage(MESSAGE_EVENT_ADVANCE, player:getName() .. " has created portals to a hunting instance. You can use them to join.")
                end
            end
        end
    end
    
    return true
end

-- Function to show the hunting area selection modal
function showHuntingAreaSelection(player, devicePosition)
    -- Create a modal window
    local window = ModalWindow(1000, "Select Hunting Area", "Choose a hunting area to create portals to:")
    
    -- Add hunting areas from config
    for name, area in pairs(InstanceMaps) do
        -- Check level requirements
        local playerLevel = player:getLevel()
        local meetsRequirements = true
        
        if area.minLevel and playerLevel < area.minLevel then
            meetsRequirements = false
        end
        
        if area.maxLevel and playerLevel > area.maxLevel then
            meetsRequirements = false
        end
        
        -- Add choice if player meets requirements
        if meetsRequirements then
            local description = area.description or name
            if area.minLevel or area.maxLevel then
                description = description .. " (Level "
                if area.minLevel then
                    description = description .. area.minLevel
                else
                    description = description .. "1"
                end
                description = description .. "-"
                if area.maxLevel then
                    description = description .. area.maxLevel
                else
                    description = description .. "999"
                end
                description = description .. ")"
            end
            
            window:addChoice(name, description)
        end
    end
    
    -- Add party instance option if player is in a party
    local party = player:getParty()
    if party then
        window:addButton("partyInstance", "Create Party Instance")
    end
    
    -- Add personal instance button
    window:addButton("personalInstance", "Create Personal Instance")
    
    -- Add cancel button
    window:addButton("cancel", "Cancel")
    
    -- Set callback function
    window:setCallback(function(player, button, choice)
        if button == "cancel" then
            return true
        end
        
        local isPartyInstance = (button == "partyInstance")
        
        -- Check if player is already in an instance
        if isPlayerInInstance(player:getId()) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are already in a hunting instance. Type !leave to exit first.")
            return true
        end
        
        -- Create instance
        local instanceId = createPlayerInstance(player:getId(), InstanceMaps[choice].mapFile, 
                                              InstanceMaps[choice].entryPosition, player:getPosition(), isPartyInstance)
        
        if not instanceId then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to create hunting instance.")
            return true
        end
        
        -- Create portals
        createPortals(player, devicePosition, instanceId, choice)
        
        return true
    end)
    
    -- Show the window to the player
    window:sendToPlayer(player)
    
    return true
end

-- Function to handle portal device usage
function portalDevice.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Check if player is already in an instance
    if isPlayerInInstance(player:getId()) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are already in a hunting instance. Type !leave to exit first.")
        return true
    end
    
    -- Show hunting area selection
    return showHuntingAreaSelection(player, fromPosition)
end

-- Function to handle portal usage
function onUsePortal(player, item, fromPosition, target, toPosition, isHotkey)
    -- Get instance ID from portal unique ID
    local portalUniqueId = item:getAttribute(ITEM_ATTRIBUTE_UNIQUEID)
    if not portalUniqueId then
        return false
    end
    
    local instanceId = math.floor(portalUniqueId / 100)
    local portalIndex = portalUniqueId % 100
    
    -- Get instance data
    local instance = getInstanceById(instanceId)
    if not instance then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "This portal leads nowhere.")
        return true
    end
    
    -- Check if player can enter the instance
    local canEnter = false
    
    -- If this is a party instance, check if the player is in the party
    if instance.isPartyInstance then
        local party = player:getParty()
        if party and party:getId() == instance.partyId then
            canEnter = true
        end
    end
    
    -- If the player is the owner of the instance, they can always enter
    if instance.ownerId == player:getId() then
        canEnter = true
    end
    
    -- Check if the player is already in the instance's player list
    for _, playerId in ipairs(instance.playerIds) do
        if playerId == player:getId() then
            canEnter = true
            break
        end
    end
    
    if not canEnter then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You cannot enter this instance.")
        return true
    end
    
    -- Teleport the player to the instance
    local success = teleportToPlayerInstance(player:getId(), instanceId)
    if not success then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to teleport to hunting instance.")
        return true
    end
    
    return true
end

-- Register the portal device action
portalDevice:id(PORTAL_DEVICE_ID)
portalDevice:register()

-- Register portal action
local portalAction = Action()
portalAction:id(PORTAL_ITEM_ID)
portalAction:function(onUsePortal)
portalAction:register()

-- Helper functions for instance data management
function getInstanceById(instanceId)
    -- This is a placeholder. In a real implementation, you would retrieve the instance data from the C++ side
    -- For now, we'll use a global table to store instance data
    if not GlobalInstanceData then
        GlobalInstanceData = {}
    end
    
    return GlobalInstanceData[instanceId]
end

function updateInstanceData(instanceId, data)
    -- This is a placeholder. In a real implementation, you would update the instance data on the C++ side
    -- For now, we'll use a global table to store instance data
    if not GlobalInstanceData then
        GlobalInstanceData = {}
    end
    
    GlobalInstanceData[instanceId] = data
end

-- Hook into player death event to handle portal consumption
local deathEvent = CreatureEvent("PortalDeathEvent")

function deathEvent:onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    if not creature:isPlayer() then
        return true
    end
    
    local player = creature:getPlayer()
    if not player then
        return true
    end
    
    -- Check if player is in an instance
    local instanceId = getPlayerInstanceId(player:getId())
    if instanceId == 0 then
        return true
    end
    
    -- Get instance data
    local instance = getInstanceById(instanceId)
    if not instance or not instance.portals then
        return true
    end
    
    -- Consume a portal
    if instance.remainingPortals > 0 then
        instance.remainingPortals = instance.remainingPortals - 1
        
        -- Remove a portal item
        local portal = instance.portals[instance.remainingPortals + 1]
        if portal then
            portal:remove()
            instance.portals[instance.remainingPortals + 1] = nil
        end
        
        -- Update instance data
        updateInstanceData(instanceId, instance)
        
        -- Notify the player
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have " .. instance.remainingPortals .. " portals remaining.")
        
        -- If no portals remain, remove the instance
        if instance.remainingPortals <= 0 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have no more portals remaining. The instance will be closed.")
            
            -- Teleport all players out of the instance
            for _, playerId in ipairs(instance.playerIds) do
                local member = Player(playerId)
                if member then
                    teleportFromPlayerInstance(playerId)
                    member:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The instance has been closed because all portals were consumed.")
                end
            end
            
            -- Remove the instance
            removePlayerInstance(instanceId)
        end
    end
    
    return true
end

deathEvent:register()