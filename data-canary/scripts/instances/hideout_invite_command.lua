-- Hideout Invite Command Script
-- This script handles the !invite command to invite players to your hideout

local inviteCommand = TalkAction("!invite")

function inviteCommand.onSay(player, words, param)
    -- Check if player has a hideout
    local hideoutId = getPlayerHideoutId(player:getId())
    if hideoutId == 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have a hideout. Type !hideout to create one.")
        return false
    end
    
    -- Check if player is in their hideout
    local currentInstanceId = getPlayerInstanceId(player:getId())
    if currentInstanceId ~= hideoutId then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You must be in your hideout to invite players.")
        return false
    end
    
    -- Check if a target player was specified
    if param == "" then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Please specify a player to invite. Usage: !invite <player name>")
        return false
    end
    
    -- Find the target player
    local targetPlayer = Player(param)
    if not targetPlayer then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Player not found.")
        return false
    end
    
    -- Check if the target player is already in an instance
    if isPlayerInInstance(targetPlayer:getId()) then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "That player is already in an instance.")
        return false
    end
    
    -- Send invitation to the target player
    sendHideoutInvitation(player, targetPlayer, hideoutId)
    
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have invited " .. targetPlayer:getName() .. " to your hideout.")
    return true
end

-- Function to send a hideout invitation to a player
function sendHideoutInvitation(inviter, invitee, hideoutId)
    -- Create a modal window for the invitation
    local window = ModalWindow(1001, "Hideout Invitation", inviter:getName() .. " has invited you to their hideout.")
    
    -- Add accept and decline buttons
    window:addButton("accept", "Accept")
    window:addButton("decline", "Decline")
    
    -- Set callback function
    window:setCallback(function(player, button, choice)
        if button == "accept" then
            -- Check if the hideout still exists
            if not getInstanceById(hideoutId) then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The hideout no longer exists.")
                return true
            end
            
            -- Add player to the hideout's allowed players
            addPlayerToInstance(player:getId(), hideoutId)
            
            -- Teleport player to the hideout
            local success = teleportToPlayerInstance(player:getId(), hideoutId)
            if not success then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Failed to teleport to hideout.")
                return true
            end
            
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have entered " .. inviter:getName() .. "'s hideout.")
            inviter:sendTextMessage(MESSAGE_EVENT_ADVANCE, player:getName() .. " has accepted your invitation.")
        else
            inviter:sendTextMessage(MESSAGE_EVENT_ADVANCE, player:getName() .. " has declined your invitation.")
        end
        
        return true
    end)
    
    -- Show the window to the invitee
    window:sendToPlayer(invitee)
end

inviteCommand:register()