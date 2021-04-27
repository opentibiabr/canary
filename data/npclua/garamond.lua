local npcType = Game.createNpcType("Garamond")
local npcConfig = {}

npcConfig.description = "Garamond"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
    lookType = 432,
    lookHead = 0,
    lookBody = 113,
    lookLegs = 109,
    lookFeet = 107,
    lookAddons = 2
}

npcConfig.flags = {
    floorchange = false
}

npcType.onThink = function(npc, interval)
end

npcType.onAppear = function(npc, creature)
    Spdlog.info("onAppear")
end

npcType.onDisappear = function(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
end

npcType:register(npcConfig)
