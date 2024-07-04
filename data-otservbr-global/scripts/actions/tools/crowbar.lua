local function the_ape_city(player, item, target, toPosition)
    if target:getActionId() == 40040 and target:getId() == 4848 then

        local storageValue = player:getStorageValue(Storage.Quest.U7_6.TheApeCity.Casks)
        if storageValue < 0 then
            storageValue = 0
        end

        if storageValue >= 3 then
            return true
        end

        player:setStorageValue(Storage.Quest.U7_6.TheApeCity.Casks, storageValue + 1)

        return true
    end
    return false
end

local crowbarActions = {
    the_ape_city = the_ape_city
}

local function onUseCrowbar(player, item, fromPosition, target, toPosition, isHotkey)
    for actionName, actionFunction in pairs(crowbarActions) do
        if actionFunction(player, item, target, toPosition) then
            return true
        end
    end
    return true
end

local crowbar = Action()

function crowbar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    return onUseCrowbar(player, item, fromPosition, target, toPosition, isHotkey)
end

crowbar:id(3304)
crowbar:register()
