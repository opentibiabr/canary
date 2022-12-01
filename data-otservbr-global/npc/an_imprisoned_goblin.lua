local internalNpcName = "An Imprisoned Goblin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 61
}

npcConfig.flags = {
	floorchange = false
}

  local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onAppear = function(npc, creature)
  npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
  npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
  npcHandler:onSay(npc, creature, type, message)
end

npcType.onThink = function(npc, interval)
  npcHandler:onThink(npc, interval)
end

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
