local internalNpcName = "Harlow"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 151,
	lookHead = 116,
	lookBody = 77,
	lookLegs = 94,
	lookFeet = 97,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}


npcType:register(npcConfig)
