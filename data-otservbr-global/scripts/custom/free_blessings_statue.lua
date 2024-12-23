local blessItem = Action()

local onlyVipAllowed = true
local hoursCooldown = 24 -- Quantidade de horas de cooldown
local cooldownStorage = 62000

function blessItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)

    if onlyVipAllowed and not player:isVip() then
        player:sendTextMessage(MESSAGE_LOOK, "Only VIP players can use this item.")
        return true
    end

    local currentTime = os.time()
    local lastUse = player:getStorageValue(cooldownStorage)
    
    if lastUse > currentTime then
        local remainingTime = lastUse - currentTime
        local hours = math.floor(remainingTime / 3600)
        local minutes = math.floor((remainingTime % 3600) / 60)
        local seconds = remainingTime % 60
        player:sendTextMessage(MESSAGE_LOOK, string.format("You can only use this item once a day. Time remaining: %02d:%02d:%02d.", hours, minutes, seconds))
        return true
    end


    local blessCost = Blessings.getBlessingsCost(player:getLevel(), true)
    local PvPBlessCost = Blessings.getPvpBlessingCost(player:getLevel(), true)
    local hasToF = Blessings.Config.HasToF and player:hasBlessing(1) or true
    local donthavefilter = function(p, b)
        return not p:hasBlessing(b)
    end

    local missingBless = player:getBlessings(nil, donthavefilter)
    local missingBlessAmt = #missingBless + (hasToF and 0 or 1)

    if missingBlessAmt == 0 then
        player:sendTextMessage(MESSAGE_LOOK, "You are already blessed.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    for _, v in ipairs(missingBless) do
        player:addBlessing(v.id, 1)
    end

    player:sendTextMessage(MESSAGE_LOOK, "You received the remaining " .. missingBlessAmt .. " blesses.")
    player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
    player:setStorageValue(cooldownStorage, currentTime + hoursCooldown * 60 * 60)
    return true
end

blessItem:uid(62000)
blessItem:register()