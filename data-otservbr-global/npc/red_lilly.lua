local internalNpcName = "Red Lilly"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 136,
	lookHead = 96,
	lookBody = 57,
	lookLegs = 28,
	lookFeet = 47,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "Come visit my little pawnshop! General equipment and such. Don't miss it!"}
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

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "basket", clientId = 2855, buy = 6 },
	{ itemName = "beach backpack", clientId = 5949, buy = 20 },
	{ itemName = "beach bag", clientId = 5950, buy = 4 },
	{ itemName = "bottle", clientId = 2875, buy = 3 },
	{ itemName = "bucket", clientId = 2873, buy = 4 },
	{ itemName = "candelabrum", clientId = 2912, buy = 8 },
	{ itemName = "candlestick", clientId = 2917, buy = 2 },
	{ itemName = "closed trap", clientId = 3481, buy = 280, sell = 75 },
	{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
	{ itemName = "cup", clientId = 2881, buy = 2 },
	{ itemName = "document", clientId = 2818, buy = 12 },
	{ itemName = "fishing rod", clientId = 3483, buy = 150, sell = 40 },
	{ itemName = "hand auger", clientId = 31334, buy = 25 },
	{ itemName = "machete", clientId = 3308, buy = 35, sell = 6 },
	{ itemName = "net", clientId = 31489, buy = 50 },
	{ itemName = "parchment", clientId = 2817, buy = 8 },
	{ itemName = "pick", clientId = 3456, buy = 50, sell = 15 },
	{ itemName = "plate", clientId = 2905, buy = 6 },
	{ itemName = "present", clientId = 2856, buy = 10 },
	{ itemName = "rope", clientId = 3003, buy = 50, sell = 15 },
	{ itemName = "scroll", clientId = 2815, buy = 5 },
	{ itemName = "scythe", clientId = 3453, buy = 50, sell = 10 },
	{ itemName = "shovel", clientId = 3457, buy = 50, sell = 8 },
	{ itemName = "torch", clientId = 2920, buy = 2 },
	{ itemName = "vial", clientId = 2874, sell = 5 },
	{ itemName = "vial of oil", clientId = 2874, buy = 20, count = 7 },
	{ itemName = "watch", clientId = 2906, buy = 20, sell = 6 },
	{ itemName = "waterskin of water", clientId = 2901, buy = 10, count = 1 },
	{ itemName = "wooden hammer", clientId = 3459, sell = 15 },
	{ itemName = "worm", clientId = 3492, buy = 1 }
}
-- Basic
keywordHandler:addKeyword({'charlotta'}, StdModule.say, {npcHandler = npcHandler, text = "Just between you and me hun, that woman is a witch. Love potions, poison, voodoo dolls to torture your neighbour. You name it, she got it."})
keywordHandler:addKeyword({'cult'}, StdModule.say, {npcHandler = npcHandler, text = "Uh! <whispers> There are ... rumours, you know? About bloody rituals and gruesome curses ... better don't talk aloud about such issues."})
keywordHandler:addKeyword({'djinn'}, StdModule.say, {npcHandler = npcHandler, text = "Kshh!! No talks about ... the magic folk here ... This might draw their attention."})
keywordHandler:addKeyword({'eleonore'}, StdModule.say, {npcHandler = npcHandler, text = "Hard to imagine that this fat man has such a pretty daughter."})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = "Don't mention HIM in my house you fool. You call evil and mayhem upon us."})
keywordHandler:addKeyword({'food'}, StdModule.say, {npcHandler = npcHandler, text = "I am not dealing with food."})
keywordHandler:addKeyword({'governor'}, StdModule.say, {npcHandler = npcHandler, text = "I won't say anything bad about such a high-born person. That's why I remain silent hun ."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I run this little pawnshop, hun, but I think you knew that already."})
keywordHandler:addKeyword({'king'}, StdModule.say, {npcHandler = npcHandler, text = "What interest could a king have in this little settlement? If a king cares about us, there must be something important behind all this."})
keywordHandler:addKeyword({'liberty bay'}, StdModule.say, {npcHandler = npcHandler, text = "Liberty comes, liberty goes, only the bay stays. Hehe."})
keywordHandler:addKeyword({'light'}, StdModule.say, {npcHandler = npcHandler, text = "I sell torches, candelabra, and oil."})

keywordHandler:addKeyword({'loveless'}, StdModule.say, {npcHandler = npcHandler, text = "That guy is a shrewd trader, sweetie. I bet even I could learn a thing or two from him."})
keywordHandler:addAliasKeyword({'theodore'})

keywordHandler:addKeyword({'offer'}, StdModule.say, {npcHandler = npcHandler, text = "I have shovels, picks, scythes, bags, ropes, backpacks, plates, scrolls, watches, some lightsources, and other stuff. Just ask me for a {trade}."})
keywordHandler:addAliasKeyword({'buy'})
keywordHandler:addAliasKeyword({'goods'})
keywordHandler:addAliasKeyword({'sell'})
keywordHandler:addAliasKeyword({'equipment'})
keywordHandler:addAliasKeyword({'stuff'})
keywordHandler:addAliasKeyword({'ware'})

keywordHandler:addKeyword({'pirate'}, StdModule.say, {npcHandler = npcHandler, text = "Mostly, pirates are bad for business. But sometimes, they are good for business."})
keywordHandler:addKeyword({'plantations'}, StdModule.say, {npcHandler = npcHandler, text = "Sadly the workers have hardly enough money to buy something to eat and to drink. That is bad also for my business."})
keywordHandler:addKeyword({"quara"}, StdModule.say, {npcHandler = npcHandler, text = {
		"The quara are the curse of the sea. Everybody that dares to enrage the sea spirits has to fear their vengeance. They come at night to kidnap people who forgot their lucky charms at home ...",
		"Sometimes those evil beings take the most naughty children to raise them as their own underwater."}})
keywordHandler:addKeyword({'rum'}, StdModule.say, {npcHandler = npcHandler, text = "Ah, there is little in the world that comes close to the taste of rum."})
keywordHandler:addKeyword({'striker'}, StdModule.say, {npcHandler = npcHandler, text = "I heard there is a fine bounty on his head. Would be a shame though to lose such a handsome man to the executioner <winks>."})
keywordHandler:addKeyword({'sugar'}, StdModule.say, {npcHandler = npcHandler, text = "Sugar lets the money flow. We depend heavily on it."})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = "Thais might be a splendid town, but this is of no use to us here. The situation in our town gets worse with every ship full of foreigners that arrives here."})
keywordHandler:addKeyword({'venore'}, StdModule.say, {npcHandler = npcHandler, text = "I heard Venore will soon acquire several trade monopolies that will grant them wealth for centuries."})
keywordHandler:addKeyword({'voodoo'}, StdModule.say, {npcHandler = npcHandler, text = "Well, <lowers the voice to a whisper> there are several people around who know this or that about voodoo and not all of them are up to something good. Just buy some lucky charms from that old hag Charlotta to be on the safe side."})
keywordHandler:addKeyword({'wyrmslicer'}, StdModule.say, {npcHandler = npcHandler, text = "A handsome man but a bit too stiff. I think no one has ever had a chance to see him smiling."})
-- keywordHandler:addKeyword({'vial'}, StdModule.say, {npcHandler = npcHandler, text = "I will pay you 5 gold for every empty vial. Ok?"})
-- keywordHandler:addKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = "Hmm, but please keep Tibia litter free."})
-- keywordHandler:addKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = "You don't have any empty vials."})
npcHandler:setMessage(MESSAGE_GREET, "Hello sweetie. If you need general equipment, stuff like that, let me know.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye sweetie.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares. Remember that if you buy vials of oil, there's a deposit of 5 gold on the empty one.")
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
