local internalNpcName = "Bruno"
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
	lookHead = 94,
	lookBody = 66,
	lookLegs = 114,
	lookFeet = 95,
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

keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = "Well, I sell freshly caught fish. You like some? Of course, you can buy more than one at once. *grin* Just ask me for a {trade}."})
keywordHandler:addKeyword({'buy'}, StdModule.say, {npcHandler = npcHandler, text = "Well, I sell freshly caught fish. You like some? Of course, you can buy more than one at once. *grin* Just ask me for a {trade}."})
keywordHandler:addKeyword({'fish'}, StdModule.say, {npcHandler = npcHandler, text = "Well, I sell freshly caught fish. You like some? Of course, you can buy more than one at once. *grin* Just ask me for a {trade}."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Bruno."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "My job is to catch fish and to sell them here."})
keywordHandler:addKeyword({'marlene'}, StdModule.say, {npcHandler = npcHandler, text = "Ah yes, my lovely wife. God forgive her, but she can't stop talking. So my work is a great rest for my poor ears. *laughs loudly*"})
keywordHandler:addKeyword({'graubart'}, StdModule.say, {npcHandler = npcHandler, text = "I like this old salt. I learned much from him. Whatever. You like some fish? *grin*"})

npcHandler:setMessage(MESSAGE_GREET, "Ahoi, |PLAYERNAME|. You want to buy some fresh fish?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and come again!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Buy all the fish you want. It's fresh and healthy, promised.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
