local npcType = Game.createNpcType("A Beautiful Girl")
local npcConfig = {}

npcConfig.description = "A Beautiful Girl"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 140,
    lookHead = 77,
    lookBody = 81,
    lookLegs = 79,
    lookFeet = 95,
    lookAddons = 0
}

npcConfig.flags = {
    hostile = false,
    floorchange = false
}

npcType.onThink = function(npc, interval)
end

npcType.onAppear = function(npc, creature)
end

npcType.onDisappear = function(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
end

local interactions = {
    NpcInteraction:createGreetInteraction("So you have come, %s. I hoped you would not..."),
    NpcInteraction:createFarewellInteraction(),
}

npcType.onSay = function(npc, creature, type, message)
    return npc:processOnSay(message, creature, interactions)
end

npcType:register(npcConfig)
