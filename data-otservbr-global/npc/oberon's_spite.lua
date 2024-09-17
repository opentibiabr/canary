local internalNpcName = "Oberon's Spite"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 11212,
}

npcConfig.flags = {
	floorchange = false,
}

-- npcType registering the npcConfig table
npcType:register(npcConfig)
