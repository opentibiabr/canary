local config = {
    scrollId = 44811,
    premiumDays = 7,
}

local days = config.premiumDays
local premiumScroll = Action()
function premiumScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    player:addPremiumDays(days)
    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received " .. days .. " days of premium account.")
    item:remove(1)
    addEvent(function()
        if player:isPlayer() then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have " .. player:getPremiumDays() .. " days of premium account.")
        end
    end, 2500)
    return true
end

premiumScroll:id(config.scrollId)
premiumScroll:register()