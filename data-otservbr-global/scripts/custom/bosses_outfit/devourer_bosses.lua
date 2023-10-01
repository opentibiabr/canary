local bosses = {
    ["Chagorz"] = {storage = 345248},
    ["Ichgahal"] = {storage = 345249},
    ["Murcion"] = {storage = 345250},
    ["Vemiath"] = {storage = 345251},
}

local essenceBosses = CreatureEvent("spiritMount")

function essenceBosses.onKill(creature, target)
    local targetMonster = target:getMonster()
    if not targetMonster or targetMonster:getMaster() then
        return true
    end

    local bossesKilled = 0
    for _, boss in pairs(bosses) do
        if creature:getStorageValue(boss.storage) > 0 then
            bossesKilled = bossesKilled + 1
        end
    end

    local bossConfig = bosses[targetMonster:getName():lower()]
    if bossConfig then
        if creature:getStorageValue(bossConfig.storage) < 1 then
            creature:setStorageValue(bossConfig.storage, 1)
            bossesKilled = bossesKilled + 1
        end
    end

    if bossesKilled == 4 and creature:getStorageValue(345252) < 1 then
        creature:sendTextMessage(MESSAGE_INFO_DESCR, "You received the Spirit of Purity Mount.")
        creature:addMount(217)
        creature:setStorageValue(345252, 1)
    end

    return true
end

essenceBosses:register()
