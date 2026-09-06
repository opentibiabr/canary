local internalNpcName = "William"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 115,
	lookBody = 0,
	lookLegs = 67,
	lookFeet = 114,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

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

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "I wish I'd live in Thais, the city of alcohol." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "I wish I'd live in Thais, the city of alcohol." })
keywordHandler:addKeyword({ "head" }, StdModule.say, { npcHandler = npcHandler, text = "I forgot <hicks> what a job I have. Not sure about my name. <hicks> Uh!" })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "Thanks I am <hicks> drunk <giggles>." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I forgot <hicks> what a job I have. Not sure about my name. <hicks> Uh!" })
keywordHandler:addKeyword({ "karl" }, StdModule.say, { npcHandler = npcHandler, text = "A good guy with <hicks> good beer." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My Name? Uh... Wait! 'Bring down the trash, William you...' William, my name is William!" })
keywordHandler:addKeyword({ "refuge" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, refuge from <hicks> womanhood." })
keywordHandler:addKeyword({ "sewer" }, StdModule.say, { npcHandler = npcHandler, text = "The sewers are our last refuge." })
keywordHandler:addKeyword({ "tim" }, StdModule.say, { npcHandler = npcHandler, text = "Old Tim <hicks> is such a good <hicks> storyteller. I could <hicks> listen to him for hours." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Its precisely <hicks> after <hicks>." })
keywordHandler:addKeyword({ "todd" }, StdModule.say, { npcHandler = npcHandler, text = "In Todd we trust! TODD! TODD! TODD!" })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
