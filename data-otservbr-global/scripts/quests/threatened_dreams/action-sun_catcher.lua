local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local config = {
    [25733] = {
        fromPos = Position(33508, 32163, 7),
        toPos = Position(33522, 32173, 7),
        usablePeriod = "day",
        failMessage = "You are rubbing the gem in the sun catcher\'s centre but nothing happens.",
        successMessage = "The sun catcher is shining with sunlight now."
    },
    [25734] = {
        targetPos = {
            Position(33419, 32242, 7),
            Position(33484, 32192, 7),
            Position(33546, 32155, 7),
            Position(33547, 32206, 7),
            Position(33568, 32243, 7)
        },
        usablePeriod = "day",
        failMessage = "The sun has to be shining in order to strengthen the barrier. Wait for the day.",
        successMessage = {
            "As soon as you're placing the sun catcher on the stone the pattern the mosaic is infused with sunlight. The barrier strengthens.",
            "As soon as you're placing the sun catcher on the stone the pattern the mosaic is infused with sunlight. This was the last mosaic."
        },
        storageCounter = ThreatenedDreams.Mission02.ChargedSunCatcher,
        storagePos = {
            ThreatenedDreams.Mission02.SunCatcherPos01,
            ThreatenedDreams.Mission02.SunCatcherPos02,
            ThreatenedDreams.Mission02.SunCatcherPos03,
            ThreatenedDreams.Mission02.SunCatcherPos04,
            ThreatenedDreams.Mission02.SunCatcherPos05,
        }
    }
}

local sunCatcher = Action()
function sunCatcher.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local tool = config[item.itemid]
    local currentPeriod = getTibiaTimerDayOrNight(getFormattedWorldTime(time))

    if item.itemid == 25733 then
        if tool.usablePeriod ~= currentPeriod then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.failMessage)
            return true
        end

        if not player:getPosition():isInRange(tool.fromPos, tool.toPos) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.failMessage)
            return true
        end

        if player:getStorageValue(ThreatenedDreams.Mission02[1]) ~= 6
        and player:getStorageValue(ThreatenedDreams.Mission02[1]) ~= 8 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.failMessage)
            return true
        end

        if player:getStorageValue(ThreatenedDreams.Mission02[1]) == 6 then
            item:transform(25734)
            player:setStorageValue(ThreatenedDreams.Mission02.ChargedSunCatcher, 5)
        elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) == 8 then
            item:transform(25977)
        end
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.successMessage)
        iterateArea(
            function(position)
                local tile = Tile(position)
                if tile then
                    position:sendMagicEffect(CONST_ME_MAGIC_POWDER)
                end
            end,
            tool.fromPos, tool.toPos)
        return true
    elseif item.itemid == 25734 then
        if tool.usablePeriod ~= currentPeriod then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.failMessage)
            return true
        end

        if player:getStorageValue(ThreatenedDreams.Mission02[1]) == 7 then
            local counter = player:getStorageValue(tool.storageCounter)
            for i = 1,5 do
                if toPosition == tool.targetPos[i] and player:getStorageValue(tool.storagePos[i]) < 1 then
                    player:setStorageValue(tool.storagePos[i], 1)
                    player:setStorageValue(tool.storageCounter, counter - 1)
                    player:getPosition():sendMagicEffect(CONST_ME_MAGIC_POWDER)
                    if player:getStorageValue(tool.storageCounter) ~= 0 then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.successMessage[1])
                    else
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.successMessage[2])
                        item:transform(25733)
                    end
                end
            end
        end
        return true
    end
end

sunCatcher:id(25733,25734)
sunCatcher:register()
