local internalNpcName = "Gnomad"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 78,
	lookBody = 94,
	lookLegs = 94,
	lookFeet = 114,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

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

local function creatureSayCallback(npc, creature, type, message)
    local player = Player(creature)
    local playerId = player:getId()

    if not npcHandler:checkInteraction(npc, creature) then
        return false
    end

    if (MsgContains(message, "tactical")) then
        npcHandler:say(
            {"You will encounter quite a lot of beasties in the area ahead of us. The end of the cave-system is where the trouble begins though. The monsters here all serve some massive creature only known as Deathstrike. ...",
             "The creature is hidden in a well protected chamber. The good news is, we've managed to erect a crystal structure close to the cave that is able to breach its defence and teleport someone into the chamber. ...",
             "The bad new is that the crystals need a specific charge before they can work. As soon as the crystals begin to charge up, Deathstrikes' minions will frenzy and spawn in waves to crush all opposition. ...",
             "You will have to kill them quite fast, to not be overwhelmed by their numbers! Our own tries to breach the defence has proven that you'll have to endure six waves until the teleporter to Deathtstrikes' cave opens for a short 30 seconds. ...",
             "Use the GREEN command crystal in the cave to begin the charging of the teleport! Good luck."}, npc,
            creature)
        npcHandler:setTopic(playerId, 0)
    elseif (MsgContains(message, "job")) then
        npcHandler:say("I'm the gnomish tactical advisor for this area!", npc, creature)
        npcHandler:setTopic(playerId, 0)
    elseif (MsgContains(message, "crystals")) then
        npcHandler:say(
            "Ah you are amazed by our crystals, aren't you? Well, you have only seen a tiny fraction of what they are able to do.",
            npc, creature)
        npcHandler:setTopic(playerId, 0)
    elseif (MsgContains(message, "mushrooms")) then
        npcHandler:say(
            "In the last century mushrooms have become more and more important for producing raw materials and tools and less important for sustenance.",
            npc, creature)
        npcHandler:setTopic(playerId, 0)
    elseif (MsgContains(message, "gnomes")) then
        npcHandler:say(
            "We gnomes are masters of growing and working crystals and we also mastered the raising of a variety of mushrooms for different purposes.",
            npc, creature)
        npcHandler:setTopic(playerId, 0)
    end
    return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi there! I'm ready to brief you with {tactical} advice.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and take care!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
