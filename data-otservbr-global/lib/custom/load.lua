local colors = {
    grey = 3003,
    blue = 3043,
    green = 3415,
    purple = 36792,
    yellow = 34021
}

-- Messages Colors
MESSAGE_COLOR_GRAY = 3003
MESSAGE_COLOR_GREEN = 3415
MESSAGE_COLOR_BLUE = 3043
MESSAGE_COLOR_PURPLE = 36792
MESSAGE_COLOR_YELLOW = 34021

function Player.sendColoredMessage(self, message)
    for colorName, colorCode in pairs(colors) do
        message = message:gsub("{" .. colorName .. "|", "{" .. colorCode .. "|")
    end
    return self:sendTextMessage(MESSAGE_LOOT, message)
end

-- Lottery config
LOTTERY_STORAGE_MINUTE = 60001
LOTTERY_STORAGE_FINISHED = 60002
LOTTERY_STORAGE_FINISHEDHOUR = 60003
-- Lottery config end

-- hunt refiller npc
HUNT_REFILLER = {}
