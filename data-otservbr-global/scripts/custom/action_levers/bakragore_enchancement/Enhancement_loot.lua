local config = {
    ["bakragore"] = {
        chance = 3000, tiers = {
            [{   1,  10000}] = {tier = {"sanguine", true},    effect = {252, true},  itemList = {{43865, 1, 1, 2000}, {43867, 1, 1, 2000}, {43869, 1, 1, 2000}, {43871, 1, 1, 2000}, {43873, 1, 1, 2000}, {43875, 1, 1, 2000}, {43878, 1, 1, 2000}, {43880, 1, 1, 2000}, {43883, 1, 1, 2000}, {43886, 1, 1, 2000} }},
        }
    },
}

local creatureevent = CreatureEvent("onDeath_randomTierDrops")

function creatureevent.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
    local monster = config[creature:getName():lower()]
    if monster then
        local player = killer:isPlayer() and killer or mostDamageKiller:isPlayer() and mostDamageKiller or nil
        if player then
            local storages = {345000, 345001, 345002, 345003}
            local hasStorage = false
            for _, storage in ipairs(storages) do
                if player:getStorageValue(storage) == 1 then
                    hasStorage = true
                    break
                end
            end

            if not hasStorage then
                return true 
            end

            local storageCount = 0
            for _, storage in ipairs(storages) do
                if player:getStorageValue(storage) == 1 then
                    storageCount = storageCount + 1
                end
            end

            local adjustedChance = monster.chance
            if storageCount == 1 then
                adjustedChance = adjustedChance + math.floor(monster.chance * 0.05)
            elseif storageCount == 2 then
                adjustedChance = adjustedChance + math.floor(monster.chance * 0.1)
            elseif storageCount == 3 then
                adjustedChance = adjustedChance + math.floor(monster.chance * 0.15)
            elseif storageCount == 4 then
                adjustedChance = adjustedChance + math.floor(monster.chance * 0.2)
            end

            adjustedChance = math.min(adjustedChance, 10000)
            monster.chance = adjustedChance
        end
        if corpse:getEmptySlots() > 0 then
            if math.random(10000) > monster.chance then
                return true
            end
            local rand = math.random(10000)
            for chance, index in pairs(monster.tiers) do
                if chance[1] <= rand and chance[2] >= rand then
                    local rewardItems = {}
                    for i = 1, #index.itemList do
                        if math.random(10000) <= index.itemList[i][4] then
                            rewardItems[#rewardItems + 1] = i
                        end
                    end
                    if rewardItems[1] then
                        rand = math.random(#rewardItems)
                        corpse:addItem(index.itemList[rewardItems[rand]][1], math.random(index.itemList[rewardItems[rand]][2], index.itemList[rewardItems[rand]][3]))
                        if index.tier[2] == true then
                            creature:say(index.tier[1], TALKTYPE_MONSTER_SAY, false, nil, creature:getPosition())
                        end
                        if index.effect[2] == true then
                            local position = creature:getPosition()
                            for i = 1, 4 do
                                addEvent(function() position:sendMagicEffect(index.effect[1]) end, (i - 1) * 500)
                            end
                        end
                        player:setStorageValue(345000, 0)
                        player:setStorageValue(345001, 0)
                        player:setStorageValue(345002, 0)
                        player:setStorageValue(345003, 0)
                    end
                    return true
                end
            end
        end
    end
    return true
end

creatureevent:register()
