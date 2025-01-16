local gtc = TalkAction("!guild guildpoints")

-- Configurable constants
local ITEM_TABERNA_COIN = 2152 -- Example reward item (update as needed)
local REWARD_AMOUNT = 100
local REQUIRED_MEMBERS_ONLINE = 5
local COOLDOWN_STORAGE = 35551
local COOLDOWN_TIME = 24 * 60 * 60 -- 24 hours in seconds

local function rewardGuildMembers(guildMembers)
    for _, member in ipairs(guildMembers) do
        if member then
            member:addItem(ITEM_TABERNA_COIN, REWARD_AMOUNT)
            member:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
            member:sendTextMessage(MESSAGE_LOOK, "You received " .. REWARD_AMOUNT .. " taberna coins.")
        end
    end
end

local function minimalTimers(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    return (hours > 0 and (hours .. " hour(s) and ") or "") .. minutes .. " minute(s)"
end

function gtc.onSay(player, words, param)
    local targetGuild = player:getGuild()
    if not targetGuild then
        player:sendCancelMessage("You are not a member of a guild.")
        return true
    end

    if player:getGuildLevel() < 3 then
        player:sendCancelMessage("You need to be a leader of your guild.")
        return true
    end

    if player:getStorageValue(COOLDOWN_STORAGE) > os.time() then
        player:sendCancelMessage("You need to wait " .. minimalTimers(player:getStorageValue(COOLDOWN_STORAGE) - os.time()) .. " before using this command again.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    local gMembers = targetGuild:getMembersOnline()
    if #gMembers < REQUIRED_MEMBERS_ONLINE then
        player:sendCancelMessage("You need at least " .. REQUIRED_MEMBERS_ONLINE .. " members online to use this command.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    -- Query the database to validate the guild ownership
    db.asyncStoreQuery("SELECT `ownerid` FROM `guilds` WHERE `id` = " .. targetGuild:getId() .. " LIMIT 1", function(info)
        if info then
            local owner = result.getNumber(info, "ownerid")
            result.free(info)
            if owner == player:getGuid() then
                player:setStorageValue(COOLDOWN_STORAGE, os.time() + COOLDOWN_TIME)
                rewardGuildMembers(gMembers)
            else
                player:sendCancelMessage("You are not the owner of this guild.")
            end
        else
            player:sendCancelMessage("An error occurred while verifying guild ownership.")
        end
    end)

    return true
end

gtc:groupType("normal")
gtc:register()