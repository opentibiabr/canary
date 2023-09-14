local config = {
    days = 5, --- days to clean houses ---
    log = true,
    file = "data/logs/cleanhouses.txt"
}

local function doWriteLogFile(file, text)
    local f = io.open(file, "a+")
    if not f then
        return
    end

    f:write("[" .. os.date("%d/%m/%Y %H:%M:%S") .. "] " .. text .. "\n")
    f:close()
end

local event = GlobalEvent("CleanHouses")

function event.onStartup()
    local logs = "Houses cleaned:\n"
    local resultId = db.storeQuery("SELECT `h`.`id` AS `id`, `p`.`name` AS `playerName` FROM `houses` AS `h` LEFT JOIN `players` AS `p` ON `p`.`id` = `h`.`owner` WHERE `p`.`lastlogin` < UNIX_TIMESTAMP() - " .. config.days .. " * 24 * 60 * 60")
    if resultId == false then
        logs = string.format("%sThere were no houses to clean.\n", logs)
    else
        repeat
            local house = House(result.getNumber(resultId, "id"))
            local playerName = result.getString(resultId, "playerName")
            if house ~= nil then
                logs = string.format("%sHouse: %s, Owner: %s\n", logs, house:getName(), playerName)
                house:setOwnerGuid(0)
            end
        until not result.next(resultId)
        result.free(resultId)
    end

    if config.log then
        doWriteLogFile(config.file, logs)
    end
    return true
end

event:register()