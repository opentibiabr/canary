-- =====================================================
-- NPC: Cheaty - 20 Years a Cook Quest Starter
-- Local: Venore (32844, 32137, 6)
-- Sistema: Revscriptsys (Canary)
-- =====================================================

local internalNpcName = "Cheaty"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

-- Configurações básicas do NPC
npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

-- Outfit do Cheaty (Rascoohan / LookType 1371)
npcConfig.outfit = {
    lookType = 1378,
    lookHead = 71,
    lookBody = 78,
    lookLegs = 70,
    lookFeet = 79,
    lookAddons = 0,
}

npcConfig.flags = {
    floorchange = false,
}

-- Inicialização dos handlers
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

-- Callbacks obrigatórios para o novo sistema
npcType.onThink = function(npc, interval)
    npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
    npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
    npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
    npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
    npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
    npcHandler:onCloseChannel(npc, creature)
end


-- Callback principal de diálogo
local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    if not player then return false end
    local playerId = player:getId()

    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    -- Keyword: talk (iniciar quest)
    if MsgContains(message, "talk") then
        if player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine) == 1 then
            npcHandler:say("Yes, I know, you are on a mission for the {Draccoon}, so please hurry.", npc, creature)
        else
            npcHandler:say("The Draccoon has just returned after a longer inconvenient absence. He could use the help of some talented individuals and has a mission for them. Are you interested, {yes} or {no}?", npc, creature)
            npcHandler:setTopic(playerId, 1) -- Aguarda resposta yes/no
        end
        return true
    end

    -- Keyword: yes (aceitar)
    if MsgContains(message, "yes") then
        if npcHandler:getTopic(playerId) == 1 then
            if player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine) < 1 then
                --player:setStorageValue(STORAGE_STARTED, 1)
                npcHandler:say("Search for the entrance to the secret lair of the {Draccoon} at the Venore dumpster!", npc, creature)
								player:setStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine, 1)
                player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
            else
                npcHandler:say("You have already accepted the mission. Good luck!", npc, creature)
            end
            npcHandler:setTopic(playerId, 0)
        else
            npcHandler:say("I didn't quite catch that. Are you talking about the mission? Say {talk} first!", npc, creature)
        end
        return true
    end

    -- Keyword: no (recusar)
    if MsgContains(message, "no") then
        if npcHandler:getTopic(playerId) == 1 then
            npcHandler:say("Maybe another time then. Farewell!", npc, creature)
            npcHandler:setTopic(playerId, 0)
        end
        return true
    end

    -- Keywords extras (flavor)
    if MsgContains(message, "name") then
        npcHandler:say("I am Cheaty Chief, just call me Cheaty, no need for formalities.", npc, creature)
        npcHandler:setTopic(playerId, 0)
        return true
    end

    if MsgContains(message, "draccoon") then
        npcHandler:say("The Draccoon is a magnificent creature, somewhat like a rascoohan, somewhat like a dragon. He taught me my first few spells when I was a little cub.", npc, creature)
        npcHandler:setTopic(playerId, 0)
        return true
    end

    return true
end

-- Mensagens padrão
npcHandler:setMessage(MESSAGE_GREET, "Be greeted, |PLAYERNAME|! My friend, the Draccoon, wants to have a {talk} with you!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye, |PLAYERNAME|!")

-- Registrar callback e módulo de foco
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- Registrar o NPC no engine
npcType:register(npcConfig)
