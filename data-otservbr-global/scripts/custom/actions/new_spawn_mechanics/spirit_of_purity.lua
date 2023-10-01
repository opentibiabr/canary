local SpiritOfPurity = Action()
function SpiritOfPurity.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    
    -- Check if the player already has the mount
    if player:hasMount(218) then
        player:sendTextMessage(MESSAGE_INFO_DESCR, "You already have the Spirit of Purity mount.")
        return true
    end
    
    local requiredItemCount = 4
    local itemId = 44048
    
    -- Check if the player has enough items
    if player:getItemCount(itemId) >= requiredItemCount then
        -- Remove the required items from the player's backpack
        player:removeItem(itemId, requiredItemCount)
        
        -- Add the mount to the player
        player:addMount(218)
        
        -- Send a success message to the player
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You received the Spirit of Purity Mount.")
    else
        -- Send a message if the player doesn't have enough items
        player:sendCancelMessage("You need at least " .. requiredItemCount .. " " .. ItemType(itemId):getName() .. " to get the mount.")
    end
    
    return true
end

SpiritOfPurity:id(44048)
SpiritOfPurity:register()