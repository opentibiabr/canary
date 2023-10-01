local bosses = {
    ["bakragore"] = {storage = 345008},
}

local bakragore = CreatureEvent("bakragoreOutfit")
function bakragore.onKill(creature, target)
    local targetMonster = target:getMonster()
    if not targetMonster or targetMonster:getMaster() then
        return true
    end
    local bossConfig = bosses[targetMonster:getName():lower()]
    if not bossConfig then
        return true
    end
    for key, value in pairs(targetMonster:getDamageMap()) do
        local attackerPlayer = Player(key)
        if attackerPlayer then
            if bossConfig.storage == 0 then
                attackerPlayer:setStorageValue(bossConfig.storage, 1)
            end
        end
    end
    local bossesKilled = creature:getStorageValue(345008)
    for value in pairs(bosses) do
        if creature:getStorageValue(bosses[value].storage) < 2 then
            creature:setStorageValue(345008, bossesKilled + 1)
        end
    end
    if bossesKilled > 0 and bossesKilled < 2 then
        if bossesKilled == 1 then
            if creature:getSex() == PLAYERSEX_FEMALE then
                creature:sendTextMessage(MESSAGE_INFO_DESCR, "You received the Decaying Defender full outfit.")
                creature:addOutfit(1663)
                creature:addOutfitAddon(1663, 1)
                creature:addOutfitAddon(1663, 2)
            elseif creature:getSex() == PLAYERSEX_MALE then
                creature:sendTextMessage(MESSAGE_INFO_DESCR, "You received the Decaying Defender full outfit.")
                creature:addOutfit(1662)
                creature:addOutfitAddon(1662, 1)
                creature:addOutfitAddon(1662, 2)
            end
        end
    end
    return true
end
bakragore:register()
