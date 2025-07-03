local forcePeriodCommand = TalkAction("/forceperiod")

function forcePeriodCommand.onSay(player, words, param)
    logCommand(player, words, param)
    param = param:lower():trimSpace()

    if param == "" then
        player:sendCancelMessage("Usage: /forceperiod day|night|auto")
        return true
    end

    if param == "day" or param == "night" then
        forcePeriod = param
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Forcing period: " .. param)
        -- Trigger the period change event
        local period = param == "night" and LIGHT_STATE_SUNSET or LIGHT_STATE_SUNRISE
    elseif param == "auto" then
        forcePeriod = false
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Automatic period restored.")
        -- Trigger the period change event with the current game period
        local period = getTibiaTimerDayOrNight() == "night" and LIGHT_STATE_SUNSET or LIGHT_STATE_SUNRISE
    else
        player:sendCancelMessage("Usage: /forceperiod day|night|auto")
        return true
    end

    return true
end

forcePeriodCommand:separator(" ")
forcePeriodCommand:groupType("god")
forcePeriodCommand:register()