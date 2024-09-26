local exerciseCharges = 2500
local rewardStorage = 300000
local nivel = 40
local reward = TalkAction("!reward")

local function getFormattedTime(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local seconds = seconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function onRewardCommand(player)
    if player:getStorageValue(rewardStorage) >= os.time() then
        local timeRemaining = player:getStorageValue(rewardStorage) - os.time()
        local formattedTime = getFormattedTime(timeRemaining)
        player:sendCancelMessage(string.format("Ya has cobrado tu recompensa diaria. Espera %s para volver a intentarlo.", formattedTime))
    else
        player:setStorageValue(rewardStorage, os.time() + 24 * 60 * 60)
        player:getPosition():sendMagicEffect(CONST_ME_SMOKE)

        local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)

        if player:isSorcerer() then
            inbox:addItem(28545, exerciseCharges)
        elseif player:isDruid() then
            inbox:addItem(28544, exerciseCharges)
        elseif player:isPaladin() then
            inbox:addItem(28543, exerciseCharges)
        elseif player:isKnight() then
            if player:getSkillLevel(SKILL_SWORD) > player:getSkillLevel(SKILL_CLUB) and
                player:getSkillLevel(SKILL_SWORD) > player:getSkillLevel(SKILL_AXE) then
                inbox:addItem(28540, exerciseCharges)
            elseif player:getSkillLevel(SKILL_CLUB) > player:getSkillLevel(SKILL_SWORD) and
                player:getSkillLevel(SKILL_CLUB) > player:getSkillLevel(SKILL_AXE) then
                inbox:addItem(28542, exerciseCharges)
            elseif player:getSkillLevel(SKILL_AXE) > player:getSkillLevel(SKILL_SWORD) and
                player:getSkillLevel(SKILL_AXE) > player:getSkillLevel(SKILL_CLUB) then
                inbox:addItem(28541, exerciseCharges)
            end
        end
    end
end

function reward.onSay(player, words, param)
    if player then
        if player:getLevel() >= nivel then
            onRewardCommand(player)
        else
            player:sendCancelMessage("No cumples con el nivel requerido para recibir la recompensa diaria Nivel minimo 40.")
        end
    end
end

reward:groupType("normal")
reward:register()
