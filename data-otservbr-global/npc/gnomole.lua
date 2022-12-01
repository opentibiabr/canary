local internalNpcName = "Gnomole"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 493,
	lookHead = 95,
	lookBody = 57,
	lookLegs = 57,
	lookFeet = 114
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
            {"Since you are seasoned adventurers I'll skip the basics and jump right to the important part! This cave system is overrun by the minions of ... ah well, the greatest shame of gnomekind. ...",
             "That traitorous gnome, known as Gnomevil, who was my pupil before his changeover to the dark side of gnomedom, has abandoned all gnomish ethics and joined forces with our enemies. ...",
             "It's hard to tell what led to his downfall. In the end he seems to have forgotten the principle that with small stature comes great responsibility. ...",
             "He became tainted and corrupted by evil, obviously enough to grow in size, which is always an indicator for evil of course. ...",
             "Now he commands his armies in the name of those below and hides in his lair protected by layers of thick crystal that only he can form and change due to his corrupted powers! ...",
             "There is one thing though that could cause his downfall! His corruption has spread to his minions and in his lair there are some infected weepers that are full of parasites. ...",
             "These parasites will spread a fluid that will weaken the integrity of the crystals in front of Gnomevils lair when they die. The entrance is marked with crystal columns, so you can't miss it. ...",
             "You have to kill enough of the parasites DIRECTLY in front of the crystals. Eventually the columns will collapse and allow you entrance to Gnomevils lair. ...",
             "Take care though, due to Gnomevils power the crystals will grow back quite fast. Better manage the parasites in quick succession or everything will be for naught. ..., Enter his lair and bring an end to his despicable reign!"}, npc,
            creature)
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
