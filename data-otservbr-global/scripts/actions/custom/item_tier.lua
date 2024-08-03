local forge = Action()

local count = 1
local porcentagem = 100 -- porcentagem de chance de forjar
local chance = { -- cada id significa 10% de chance de acerto
    [1] = 100,
    [2] = 90,
    [3] = 80,
    [4] = 70,
    [5] = 60,
    [6] = 30,
    [7] = 20,
    [8] = 15,
    [9] = 10,
    [10] = 5
}

function forge.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or not target:isItem() then return false end

    local targetId = target:getId()
    local targetTier = target:getTier()
    local goldcount = ((target:getTier() * 0) + 0)
    local description = target:getDescription()
    local classificationString = string.match(description, "Classification: .")
	local classification = 0

    if classificationString then

        if (classificationString == 'Classification: 2' and targetTier == 2) or
            (classificationString == 'Classification: 3' and targetTier == 3) or
            (classificationString == 'Classification: 4' and targetTier == 10) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                                   "Este item ja tem o nivel maximo.")
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                                   "Este item ja tem o nivel maximo.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return true
        end

    else

        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                               "Este Item nao pode ser Forjado.")
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                               "Este Item nao pode ser Forjado.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)

        return true

    end

    if targetTier == 10 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                               "Este Item ja tem o nivel maximo de Forja.")
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                               "Este Item ja tem o nivel maximo de Forja.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    if item:getCount(38644) <= 0 then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                               "Voce nao tem a quantidade de items necessaria para forjar.")
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                               "Voce nao tem a quantidade de items necessaria para forjar.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end

    local canForge = false
    local sameTierItem
    cylinder = player:getSlotItem(CONST_SLOT_BACKPACK)
    if cylinder and cylinder:isContainer() then
        for i = 0, cylinder:getSize() - 1 do
            local itemSearch = cylinder:getItem(i)
            if target:getTier() == 0 or itemSearch:getId() == target:getId() and
                itemSearch:getTier() == target:getTier() and
                target:getUniqueId() ~= itemSearch:getUniqueId() then
                canForge = true
                sameTierItem = itemSearch
            end
        end
    end

    if canForge then
        if not player:removeMoneyBank(goldcount) then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                                   "Voce precisa ter " .. goldcount ..
                                       " de gold para realizar a tentativa de forja.")
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                                   "Voce precisa ter " .. goldcount ..
                                       " de gold para realizar a tentativa de forja.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return true
        end

        local rand = math.random(100)
        local chanceTier = target:getTier() and target:getTier() or 0
        if targetTier >= 1 then
            if rand > chance[chanceTier] then
                TextMessage(MESSAGE_EVENT_ADVANCE, "A Forja Falhou.")
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A Forja Falhou.")
                player:getPosition():sendMagicEffect(CONST_ME_POFF)
                item:remove(1)
                return true
            end
        end

        if target:setTier(targetTier + 1) then
            local clone = target:clone()
            target:remove(1)
            player:addItemEx(clone, true, CONST_SLOT_WHEREEVER)
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                                   "Parabens, o item foi forjado.")
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                                   "Parabens, o item foi forjado.")
            player:getPosition():sendMagicEffect(50)
            item:remove(1)
            if sameTierItem then sameTierItem:remove(1) end
        end
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE,
                               "Voce precisa de um item do mesmo tier.")
    end

    return true
end

forge:id(45095)
forge:register()
