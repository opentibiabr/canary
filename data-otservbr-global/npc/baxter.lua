local internalNpcName = "Baxter"
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
	lookHead = 77,
	lookBody = 29,
	lookLegs = 29,
	lookFeet = 115,
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
	{ text = "People of Thais, bring honour to your king by fighting in the orc war!" },
	{ text = "The orcs are preparing for war!!!" },
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

npcHandler:setMessage(MESSAGE_GREET, "LONG LIVE KING TIBIANUS!")
npcHandler:setMessage(MESSAGE_FAREWELL, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "LONG LIVE THE KING!")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Do you bring freshly killed rats for a bounty of 1 gold each? By the way, I also buy orc teeth and other stuff you ripped from their bloody corp... I mean... well, you know what I mean.")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "bricklayer kit" }, StdModule.say, { npcHandler = npcHandler, text = "You need one kit for each wall. Ask me for a trade if you need some." })
keywordHandler:addKeyword({ "secret police" }, StdModule.say, { npcHandler = npcHandler, text = "Ask a higher official about that." })
keywordHandler:addKeyword({ "first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "My grandfather had seen it with his own eyes!" })
keywordHandler:addKeyword({ "silver guard" }, StdModule.say, { npcHandler = npcHandler, text = "The best sorcerers, paladins, knights, or druids of our forces are chosen to serve as Silver Guards. They are the king's bodyguards." })
keywordHandler:addKeyword({ "battlegroup" }, StdModule.say, { npcHandler = npcHandler, text = "There are the Dogs of War, the Red Guards, and the Silver Guards." })
keywordHandler:addKeyword({ "dogs of war" }, StdModule.say, { npcHandler = npcHandler, text = "They are our main army." })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "I'm healthy and vigilant." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "Gorn and I searched for this weapon in the darkest corners of each dungeon, but we didn't find the slightest hint." })
keywordHandler:addKeyword({ "red guard" }, StdModule.say, { npcHandler = npcHandler, text = "They are our special forces. Some serve as city guards, others as secret police." })
keywordHandler:addKeyword({ "benjamin" }, StdModule.say, { npcHandler = npcHandler, text = "He was one of the king's best generals, now he's a bit ...uhm... forgetful." })
keywordHandler:addKeyword({ "criminal" }, StdModule.say, { npcHandler = npcHandler, text = "Too many criminals roam our streets nowadays, the Red Guards will take care of them." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "He's harmless. But I doubt he'd be much help in the war against the orcs." })
keywordHandler:addKeyword({ "chester" }, StdModule.say, { npcHandler = npcHandler, text = "This man is paranoid, but I guess that's useful in his job." })
keywordHandler:addKeyword({ "subject" }, StdModule.say, { npcHandler = npcHandler, text = "We all live under the benevolent guidance of our king." })
keywordHandler:addKeyword({ "orc war" }, StdModule.say, { npcHandler = npcHandler, text = "I have already told you about your mission! Haven't you wrote down everything in your logbook? Look in there if you need to refresh your memory." })
keywordHandler:addKeyword({ "lunatic" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "castle" }, StdModule.say, { npcHandler = npcHandler, text = "His Royal Highness ordered that the castle be open for all his subjects." })
keywordHandler:addKeyword({ "leader" }, StdModule.say, { npcHandler = npcHandler, text = "King Tibianus III is our wise and just leader!" })
keywordHandler:addKeyword({ "harsky" }, StdModule.say, { npcHandler = npcHandler, text = "He's a soldier of the Silver Guards." })
keywordHandler:addKeyword({ "stutch" }, StdModule.say, { npcHandler = npcHandler, text = "He's a soldier of the Silver Guards." })
keywordHandler:addKeyword({ "partos" }, StdModule.say, { npcHandler = npcHandler, text = "He was wanted for a long time and was finally caught stealing some time ago." })
keywordHandler:addKeyword({ "stupid" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "tyrant" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "guard" }, StdModule.say, { npcHandler = npcHandler, text = "Our brave army, which protects our city, consists of three battle groups." })
keywordHandler:addKeyword({ "fruit" }, StdModule.say, { npcHandler = npcHandler, text = "I heard he stole some fruit he's obsessed with and got incautious." })
keywordHandler:addKeyword({ "idiot" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "Our brave army, which protects our city, consists of three battle groups." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "The royal jester. I don't think he's funny." })
keywordHandler:addKeyword({ "city" }, StdModule.say, { npcHandler = npcHandler, text = "Now that the king returned, we will clean the city from all dubious persons." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "An old friend of mine. He was once a great warrior and adventurer. Now he's running a shop." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "King Tibianus III is our wise and just leader!" })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "It's rumoured that Ferumbras is planning a new attack on this town." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm a proud member of the king's army. It's my duty to guard the castle. Sometimes I have to deal with less important work though." })
keywordHandler:addKeyword({ "our" }, StdModule.say, { npcHandler = npcHandler, text = "I'm a proud member of the king's army. It's my duty to guard the castle. Sometimes I have to deal with less important work though." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "He's a fine blacksmith. Almost all of our weapons are made by him." })
keywordHandler:addKeyword({ "tbi" }, StdModule.say, { npcHandler = npcHandler, text = "There is almost nothing known about that organisation." })
keywordHandler:addKeyword({ "rat" }, StdModule.say, { npcHandler = npcHandler, text = "Do you bring freshly killed rats for a bounty of 1 gold each? Ask me for a trade if you want to sell them." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bricklayers kit", clientId = 7785, buy = 100 },
	{ itemName = "broken helmet", clientId = 11453, sell = 20 },
	{ itemName = "broken shamanic staff", clientId = 11452, sell = 35 },
	{ itemName = "dead rat", clientId = 2418, sell = 1 },
	{ itemName = "orc leather", clientId = 11479, sell = 30 },
	{ itemName = "orc tooth", clientId = 10196, sell = 150 },
	{ itemName = "orcish gear", clientId = 11477, sell = 85 },
	{ itemName = "shamanic hood", clientId = 11478, sell = 45 },
	{ itemName = "skull belt", clientId = 11480, sell = 80 },
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
