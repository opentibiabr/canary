local npcType = Game.createNpcType("NPC Canary (Lua)")
local npcConfig = {}

npcConfig.description = "Canary"

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 1000
npcConfig.walkRadius = 10

npcConfig.outfit = {
	lookType = 128,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 2,
	lookMount = 42
}

npcConfig.voices = {
	interval = 5000,
	chance = 20,
	{ text = "Welcome to the Canary Server!" }
}

npcConfig.flags = {
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

-- This is the npc interactions (called on npc:processOnSay)
local interactions = {
	-- Greet message
	NpcInteraction:createGreetInteraction("Hello, you need more info about {canary}?"),
	NpcInteraction:createReplyInteraction({"canary"}, "The goal is for Canary to be an 'engine', that is, it will be a server with a 'clean' datapack, with as few things as possible, thus facilitating development and testing. See more on our {discord group}"),
	NpcInteraction:createReplyInteraction({"discord group"}, "This the our discord group link: https://discordapp.com/invite/3NxYnyV"),
	NpcInteraction:createFarewellInteraction(),
}

npcType.onSay = function(npc, creature, type, message)
	-- Call the table "interactions"
	return npc:processOnSay(message, creature, interactions)
end

npcType:register(npcConfig)
