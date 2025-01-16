local foods = {
    [ITEM_REVOADA_PIZZA] = { duration = 22, message = "Huuumm...", effect = CONST_ME_MAGIC_GREEN },
    -- Adicione mais alimentos conforme necessário
}

local revoadaFood = Action()

function revoadaFood.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local itemFood = foods[item.itemid]
    if not itemFood then
        player:sendTextMessage(MESSAGE_FAILURE, "This item cannot be consumed.")
        return false
    end

    -- Configuração da regeneração
    local condition = player:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
    local maxTicks = 1200 -- Máximo de regeneração em segundos
    local foodDuration = itemFood.duration * 12

    if condition and math.floor(condition:getTicks() / 1000 + foodDuration) >= maxTicks then
        player:sendTextMessage(MESSAGE_FAILURE, "You are full.")
        return true
    end

    -- Aplicar regeneração e mensagem
    player:feed(foodDuration)
    player:say(itemFood.message, TALKTYPE_MONSTER_SAY)
    player:updateSupplyTracker(item)
    player:getPosition():sendSingleSoundEffect(SOUND_EFFECT_TYPE_ACTION_EAT, player:isInGhostMode() and nil or player)

    -- Aplicar efeito visual
    if itemFood.effect then
        player:getPosition():sendMagicEffect(itemFood.effect)
    end

    return true
end

-- Registrar automaticamente todos os alimentos
for itemId in pairs(foods) do
    revoadaFood:id(itemId)
end

revoadaFood:register()