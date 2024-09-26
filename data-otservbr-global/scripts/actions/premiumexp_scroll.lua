local premiumexpscroll = Action()

-- Define el tiempo actual
local function getCurrentTime()
    return os.time()
end

-- Duración del boost en segundos
local BOOST_DURATION = 3600  -- 3600 segundos, 1 hora

-- Establece el tiempo de expiración del boost
local function setExperienceBoostEndTime(player, duration)
    player:setStorageValue(GameStore.Storages.experienceBoostEndTime, getCurrentTime() + duration)
end

-- Verifica si el boost está activo
local function isBoostActive(player)
    local endTime = player:getStorageValue(GameStore.Storages.experienceBoostEndTime)
    return endTime and endTime > getCurrentTime()
end

function premiumexpscroll.onUse(cid, item, fromPosition, itemEx, toPosition)
    local player = Player(cid)
    local currentXpBoostTime = player:getXpBoostTime()
    local expBoostCount = player:getStorageValue(GameStore.Storages.expBoostCount)

    -- Verifica si el boost puede usarse
    if expBoostCount >= 2 then
        player:say('You have reached the limit for today, try again after Server Save.', TALKTYPE_MONSTER_SAY)
        return true
    end
    
    -- Verifica si hay un boost activo
    if isBoostActive(player) then
        player:say('You already have an active experience boost. Wait for it to expire before using another one.', TALKTYPE_MONSTER_SAY)
        return true
    end

    -- Aplica el boost de experiencia
    player:setXpBoostPercent(80)  -- Supongamos un 85% de incremento en XP
    player:setXpBoostTime(currentXpBoostTime + BOOST_DURATION)

    -- Actualiza el contador de usos del boost
    if expBoostCount == -1 or expBoostCount < 1 then
        expBoostCount = 1
    else
        expBoostCount = expBoostCount + 1
    end
    player:setStorageValue(GameStore.Storages.expBoostCount, expBoostCount)

    -- Establece el tiempo de expiración del boost
    setExperienceBoostEndTime(player, BOOST_DURATION)

    -- Elimina el objeto
    Item(item.uid):remove(1)

    player:say('Your hour of 80% bonus XP has started!', TALKTYPE_MONSTER_SAY)
    return true
end

premiumexpscroll:id(8153)
premiumexpscroll:register()
