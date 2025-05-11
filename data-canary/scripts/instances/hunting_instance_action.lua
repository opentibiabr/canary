-- Hunting Instance Action Script
-- This script handles the action for entering a hunting instance

local huntingInstanceAction = Action()

function huntingInstanceAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    -- Check if player is already in an instance
    if isPlayerInInstance(player:getId()) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are already in a hunting instance. Type !leave to exit.")
        return true
    end
    
    -- Show a dialog to select the hunting ground type
    player:showTextDialog(item:getId(), "Select a hunting ground type:\n\n" ..
        "1. Beginner (Level 1-50)\n" ..
        "2. Intermediate (Level 51-100)\n" ..
        "3. Advanced (Level 101-200)\n" ..
        "4. Expert (Level 201+)", true)
    
    -- Store the item ID in the player's storage
    player:setStorageValue(40001, item:getId())
    
    return true
end

-- Register the action
huntingInstanceAction:id(1945) -- Replace with the actual item ID
huntingInstanceAction:register()

-- Handle the dialog response
local huntingInstanceDialog = TalkAction("!hunt")

function huntingInstanceDialog.onSay(player, words, param)
    -- Check if player has opened the dialog
    local itemId = player:getStorageValue(40001)
    if itemId <= 0 then
        return false
    end
    
    -- Reset the storage
    player:setStorageValue(40001, 0)
    
    -- Parse the selected option
    local option = tonumber(param)
    if not option or option < 1 or option > 4 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid option. Please try again.")
        return true
    end
    
    -- Map option to hunting ground type
    local mapType
    if option == 1 then
        mapType = "beginner"
    elseif option == 2 then
        mapType = "intermediate"
    elseif option == 3 then
        mapType = "advanced"
    elseif option == 4 then
        mapType = "expert"
    end
    
    -- Create the hunting instance
    createHuntingInstance(player, mapType)
    
    return true
end

huntingInstanceDialog:separator(" ")
huntingInstanceDialog:register()

-- Add a talk action to leave the hunting instance
local leaveInstanceAction = TalkAction("!leave")

function leaveInstanceAction.onSay(player, words, param)
    leaveHuntingInstance(player)
    return true
end

leaveInstanceAction:separator(" ")
leaveInstanceAction:register()