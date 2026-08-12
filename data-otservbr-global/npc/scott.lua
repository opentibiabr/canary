local internalNpcName = "Scott"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 75,
	lookBody = 38,
	lookLegs = 77,
	lookFeet = 116,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Hey there, adventurer! Need a little rest in my inn? Have some food!" },
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
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Scott." })
keywordHandler:addKeyword({ "senja" }, StdModule.say, { npcHandler = npcHandler, text = "It's a peaceful island. Cold and lonesome but I like it." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm the keeper of the inn. You can buy food here." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, I'm happy to live in this world full of thrilling things." })
keywordHandler:addKeyword({ "castle" }, StdModule.say, { npcHandler = npcHandler, text = "It is said that there are some secrets to discover around the mage's castle." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "Sometimes I travel to Carlin and visit the market." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "It's a city in the south-west of Tibia." })
keywordHandler:addKeyword({ "queen" }, StdModule.say, { npcHandler = npcHandler, text = "She is a strong and wise leader. We owe her protection from evil monsters." })
keywordHandler:addKeyword(
	{ "rumour" },
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A sailor from Carlin told me that the natives of the Ice Islands pray to different gods. I think 'Chyll' is one of them or was that the name of the northern winds?? Well, doesn't matter! Primitives! ... The only green fish I know is the one you can buy at Permaret in Edron as a 'special offer' and that would be your last meal. Trust me! ... I mean there are barbarians and barbarians, some are good, the others not. One call themselves 'Norsir' the others 'Raiders', but actually they are all the same. ... It seems that this was the reason why nobody has discovered the Ice Islands before. Something must have happened because at a moment's notice they disappeared. ... The wolves and bears protect them and tear their foes into pieces if they order them to. If you ask me, this is just gossip. ... That must be the reason why the Carlin traders are so interested in getting there. They sense gold in selling wood. ... He was writing strange things about suspicious inhabitants and something about a test to become one of them. It was very hard to read the letter, I think he was drunk as hell when he wrote it. ... I heard that they dig for valuable ore which was found in an old mine. I wonder why nobody of them has returned yet. Travellers told me that they recently moved into the caverns beneath the island. There, they are growing fresh grass and even flowers! How is that possible in a frozen cave? Some kind of magic has to be involved. ... I'm just not sure whether it is of the benevolent or the malicious kind.",
	}
)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 4 },
	{ itemName = "cheese", clientId = 3607, buy = 6 },
	{ itemName = "ham", clientId = 3582, buy = 8 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
