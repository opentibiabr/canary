local internalNpcName = "Rafzan"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 540
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

keywordHandler:addKeyword({'task'}, StdModule.say, {npcHandler = npcHandler, text = 'Are you here to get a task or to report you finished task?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'Me humble name is Rafzan. Good old goblin name meaning honest, generous and nice person, I swear!'})
keywordHandler:addKeyword({'goblin'}, StdModule.say, {npcHandler = npcHandler, text = 'Most goblins so afraid of everything, that they fight everything. Me different. Me just want trade.'})
keywordHandler:addKeyword({'human'}, StdModule.say, {npcHandler = npcHandler, text = 'You humans are so big, strong, clever and beautiful. Me really feel little and green beside you. Must be sooo fun to be human. You surely always make profit!'})
keywordHandler:addKeyword({'profit'}, StdModule.say, {npcHandler = npcHandler, text = 'To be honest to me human friend, me only heard about it, never seen one. I imagine it\'s something cute and cuddly.'})
keywordHandler:addKeyword({'swamp'}, StdModule.say, {npcHandler = npcHandler, text = 'Swamp is horrible. Slowly eating away at health of poor little goblin. No profit here at all. Me will die poor and desperate, probably eaten by giant mosquitoes.'})
keywordHandler:addKeyword({'dwarf'}, StdModule.say, {npcHandler = npcHandler, text = 'Beardmen are nasty. Always want to kill little goblin. No trade at all. Not good, not good.'})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = 'So much to do, so little help. Me poor goblin desperately needs help. Me have a few tasks me need to be done. I can offer you all money I made if you only help me a little with stuff which is easy to strong smart human but impossible for poor, little me.'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'Me heard Thais is big city with king! Must be strong and clever, to become chief of all humans. Me cannot imagine how many people you have to beat up to become king of all humans. Surely he makes lot of profit in his pretty city.'})
keywordHandler:addKeyword({'elves'}, StdModule.say, {npcHandler = npcHandler, text = 'They are mean and cruel. Humble goblin rarely trades with them. They would rather kill poor me if not too greedy for stuff only me can get them. Still, they rob me of it for a few spare coins and there is noooo profit for poor goblin.'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'Me job merchant is. Me trade with all kinds of things. Me not good trader though, so you get everything incredibly cheap! You might think me mad, but please don\'t rip off poor goblin too much. Me has four or five wives and dozens of kids to feed!'})
keywordHandler:addKeyword({'venore'}, StdModule.say, {npcHandler = npcHandler, text = 'Humans so clever. Much, much smarter than poor, stupid goblin. They have big rich town. Goblin lives here poor and hungry. Me so impressed by you strong and smart humans. So much to learn from you. Poor goblin only sees pretty city from afar. Poor goblin too afraid to go there.'})
keywordHandler:addKeyword({'gold'}, StdModule.say, {npcHandler = npcHandler, text = 'Me have seen a gold coin once or twice. So bright and shiny it hurt me poor eyes. You surely are incredibly rich human who has even three or four coins at once! Perhaps you want to exchange them for some things me offer? Just don\'t rob me too much, me little stupid goblin, have no idea what stuff is worth... you look honest, you surely pay fair price like I ask and tell if it\'s too cheap.'})
keywordHandler:addKeyword({'ratmen'}, StdModule.say, {npcHandler = npcHandler, text = 'Furry guys are strange fellows. Always collecting things and stuff. Not easy to make them share, oh there is noooo profit for little, poor me to be made. They build underground dens that can stretch quite far. Rumour has it the corym have strange tunnels that connect their different networks all over the world.'})

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "advertisement sign", clientId = 17668, buy = 75 },
	{ itemName = "backpack", clientId = 2854, buy = 10 },
	{ itemName = "bag", clientId = 2853, buy = 4 },
	{ itemName = "bottle with rat urine", clientId = 17671, buy = 150 },
	{ itemName = "fishing rod", clientId = 3483, buy = 150, sell = 30 },
	{ itemName = "guardcatcher", clientId = 17669, buy = 200 },
	{ itemName = "leather harness", clientId = 17846, sell = 750 },
	{ itemName = "life preserver", clientId = 17813, sell = 300 },
	{ itemName = "perfume gatherer", clientId = 17670, buy = 400 },
	{ itemName = "ratana", clientId = 17812, sell = 500 },
	{ itemName = "rope", clientId = 3003, buy = 50, sell = 8 },
	{ itemName = "scroll", clientId = 2815, buy = 5 },
	{ itemName = "scythe", clientId = 3453, buy = 12 },
	{ itemName = "shovel", clientId = 3457, buy = 10, sell = 2 },
	{ itemName = "spike shield", clientId = 17810, sell = 250 },
	{ itemName = "spiky club", clientId = 17859, sell = 300 },
	{ itemName = "torch", clientId = 2920, buy = 2 },
	{ itemName = "trunkhammer", clientId = 17676, buy = 150 },
	{ itemName = "worm", clientId = 3492, buy = 1 }
}
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
