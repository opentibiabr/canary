local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local config = {
    [25731] = {
        fromPos = Position(33526, 32298, 4),
        toPos = Position(33532, 32303, 4),
        usablePeriod = "night",
        failMessage = "You are rubbing the opaque glass of the vial but nothing happens.",
        successMessage = "The vial is glittering with starlight now."
    },
    [25732] = {
        targetPos = {
            Position(33442, 32201, 7),
            Position(33458, 32299, 7),
            Position(33562, 32256, 7),
            Position(33541, 32244, 7),
            Position(33529, 32187, 7)
        },
        usablePeriod = "night",
        failMessage = "The stars has to be glittering in order to strengthen the barrier. Wait for the night. ",
        successMessage = {
            "As soon as you're pouring out the vial over the dreambird tree the plant is infused with starlight. The barrier strengthens.",
            "As soon as you're pouring out the vial over the dreambird tree the plant is infused with starlight. This was the last tree."
        },
        storageCounter = ThreatenedDreams.Mission02.ChargedStarlightVial,
        storagePos = {
            ThreatenedDreams.Mission02.StarlightPos01,
            ThreatenedDreams.Mission02.StarlightPos02,
            ThreatenedDreams.Mission02.StarlightPos03,
            ThreatenedDreams.Mission02.StarlightPos04,
            ThreatenedDreams.Mission02.StarlightPos05,
        }
    }
}

local starlightVial = Action()
function starlightVial.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local tool = config[item.itemid]
    local currentPeriod = getTibiaTimerDayOrNight(getFormattedWorldTime(time))

    if item.itemid == 25731 then
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
            item:transform(25732)
            player:setStorageValue(ThreatenedDreams.Mission02.ChargedStarlightVial, 5)
        elseif player:getStorageValue(ThreatenedDreams.Mission02[1]) == 8 then
            item:transform(25976)
        end
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.successMessage)
        iterateArea(
            function(position)
                local tile = Tile(position)
                if tile then
                    position:sendMagicEffect(CONST_ME_HITAREA)
                end
            end,
            tool.fromPos, tool.toPos)
        return true
    elseif item.itemid == 25732 then
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
                    player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
                    if player:getStorageValue(tool.storageCounter) ~= 0 then
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.successMessage[1])
                    else
                        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, tool.successMessage[2])
                        item:transform(25731)
                    end
                end
            end
        end
        return true
    end
end

starlightVial:id(25731,25732)
starlightVial:register()
