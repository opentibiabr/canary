local internalNpcName = "Sharon"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 324,
	lookHead = 114,
	lookBody = 103,
	lookLegs = 8,
	lookFeet = 78,
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
keywordHandler:addKeyword({ "information" }, StdModule.say, { npcHandler = npcHandler, text = "I can tell you about the requirements for a transfer, and about what happens to your skills, quests, money and items. ... I can also check if you fulfil the requirements. And I can then teleport you to the departure platform." })
keywordHandler:addKeyword({ "inventory" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, you will also keep the items in your inventory." })
keywordHandler:addKeyword({ "transfer" }, StdModule.say, { npcHandler = npcHandler, text = "Character World Transfer means that you will leave this world and move to a new one to live there. If you need detailed information just ask me. I can also check if you're ready and if you are, I can teleport you to the transfer platform." })
keywordHandler:addKeyword({ "teleport" }, StdModule.say, { npcHandler = npcHandler, text = "Before I can teleport you to the transport platform, I must check if you meet the requirements for a Character World Transfer first." })
keywordHandler:addKeyword(
	{ "travora" },
	StdModule.say,
	{ npcHandler = npcHandler, text = "This is how the small island that used to be here was called. We still run a Character World Transfer from the remains of it, here. ... It was nothing much, just a speck in the ocean. But after a sea quake, most of it was swallowed by the sea. But it is still a magical place where we can send you to another world, if you wish." }
)
keywordHandler:addKeyword({ "divorce" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sorry, but I'm not qualified to divorce you. You will have to go to a priest on the Mainland for that." })
keywordHandler:addKeyword({ "corpse" }, StdModule.say, { npcHandler = npcHandler, text = "What!? Are you sure that's him? No, it... it cannot be. I mean, how could this happen? ... I guess he wanted to look for sunken treasures on Travora. After all, he is - was - a dwarf. <sigh> How sad." })
keywordHandler:addKeyword({ "elgar" }, StdModule.say, { npcHandler = npcHandler, text = "<sigh> He used to be my only company on Travora. But when the island sank, he became quite moody. ... I thought maybe he wanted to start a new life on the mainland. He left one night, suddenly. He didn't even say goodbye." })
keywordHandler:addKeyword({ "money" }, StdModule.say, { npcHandler = npcHandler, text = "I recommend depositing all of your gold in the bank. You will keep ALL of the money on your bank account on the new world." })
keywordHandler:addKeyword(
	{ "items" },
	StdModule.say,
	{ npcHandler = npcHandler, text = "All your items in your inventory, your inbox and your depot will be transferred. ... I recommend checking all the items you want to keep and to sell the rest; and deposit your money on your bank account. Or you could give some to friends who stay here! ... I can check if you meet all necessary requirements for a transfer." }
)
keywordHandler:addKeyword({ "depot" }, StdModule.say, { npcHandler = npcHandler, text = "No worries there. You keep all your items that are in your inventory, inbox and depot." })
keywordHandler:addKeyword({ "inbox" }, StdModule.say, { npcHandler = npcHandler, text = "You keep all items that are in your inbox when transferring to another world." })
keywordHandler:addKeyword({ "skill" }, StdModule.say, { npcHandler = npcHandler, text = "You will keep all of your skills and levels as they currently are. Easy as that." })
keywordHandler:addKeyword({ "dead" }, StdModule.say, { npcHandler = npcHandler, text = "What!? Are you sure that's him? No, it... it cannot be. I mean, how could this happen? ... I guess he wanted to look for sunken treasures on Travora. After all, he is - was - a dwarf. <sigh> How sad." })
keywordHandler:addKeyword({ "bank" }, StdModule.say, { npcHandler = npcHandler, text = "No, there's no bank here anymore. There used to be one on the island, but there's no need for one these days. You need to visit one of the major cities if you require a bank." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Sharon." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "<sigh> Time seems to stand still, here." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I help you to prepare your Character World Transfer by giving you all kind of information." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
