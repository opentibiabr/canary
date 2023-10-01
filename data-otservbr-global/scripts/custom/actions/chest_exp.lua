---- Script by Alexv45 -- Warning do not change the experience percentage unless you know what you are doing, 
---- since to higher you can kill your server, you need test it from level 10 until 2000 to see the difference, more level means more exp received.

local chestExp = Action()

local ITEM_ID = 25633 
local TIME_INTERVAL = 10 * 60 * 60 -- 10 Hours
local EXPERIENCE_PERCENTAGE = 0.008 -- DO NOT CHANGE UNLESS YOU KNOW WHAT YOU ARE DOING

function chestExp.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    
    if player then
        local lastExpTime = player:getStorageValue(ITEM_ID)
        local currentTime = os.time()
        if lastExpTime == -1 or (currentTime - lastExpTime) >= TIME_INTERVAL then
            local baseExperience = player:getExperience()
            local rewardExperience = math.floor(baseExperience * EXPERIENCE_PERCENTAGE)
            player:addExperience(rewardExperience)
            player:setStorageValue(ITEM_ID, currentTime)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received " .. rewardExperience .. " experience points.")
        else
            local remainingTime = TIME_INTERVAL - (currentTime - lastExpTime)
            local hours = math.floor(remainingTime / 3600)
            local minutes = math.floor((remainingTime % 3600) / 60)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can use this item again in " .. hours .. " hours and " .. minutes .. " minutes.")
        end
    end
    
    return true
end

chestExp:id(25633)
chestExp:register()