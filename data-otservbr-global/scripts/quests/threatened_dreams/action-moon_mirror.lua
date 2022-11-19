local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local config = {
    [25729] = {
        fromPos = Position(33518, 32209, 7),
        toPos = Position(33527, 32215, 7),
        usablePeriod = "night",
        failMessage = "The moon is not shining. Wait for the night.",
        successMessage = "The mirror is shining with the moonlight now."
    },
    [25730] = {
        targetPos = {
            Position(33386, 32215, 7),
            Position(33511, 32320, 6),
            Position(33518, 32193, 7),
            Position(33549, 32219, 7),
            Position(33597, 32182, 7)
        },
        usablePeriod = "night",
        failMessage = "The moon has to be shining. Wait for the night. Wait for the night.",
        successMessage = {
            "As soon as you're touching the moon sculpture with the mirror the sculpture is infused with moonlight. The barrier strengthens.",
            "As soon as you're touching the moon sculpture with the mirror the sculpture is infused with moonlight. This was the last sculpture."
        },
        storageCounter = ThreatenedDreams.Mission02.ChargedMoonMirror,
        storagePos = {
            ThreatenedDreams.Mission02.MoonMirrorPos01,
            ThreatenedDreams.Mission02.MoonMirrorPos02,
            ThreatenedDreams.Mission02.MoonMirrorPos03,
            ThreatenedDreams.Mission02.MoonMirrorPos04,
            ThreatenedDreams.Mission02.MoonMirrorPos05,
        }
    }
}

local moonMirror = Action()
function moonMirror.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local tool = config[item.itemid]
    local currentPeriod = getTibiaTimerDayOrNight(getFormattedWorldTime(time))

    if item.itemid == 25729 then
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
            item:transform(25730)
            player:setStorageValue(ThreatenedDreams.Mission02.ChargedMoonMirror, 5)
        elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) == 8 then
            item:transform(25975)
        end
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.successMessage)
        iterateArea(
            function(position)
                local tile = Tile(position)
                if tile then
                    position:sendMagicEffect(CONST_ME_THUNDER)
                end
            end,
            tool.fromPos, tool.toPos)
        return true
    elseif item.itemid == 25730 then
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
                    player:getPosition():sendMagicEffect(CONST_ME_THUNDER)
                    if player:getStorageValue(tool.storageCounter) ~= 0 then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.successMessage[1])
                    else
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.successMessage[2])
                        item:transform(25729)
                    end
                end
            end
        end
        return true
    end
end

moonMirror:id(25729,25730)
moonMirror:register()
