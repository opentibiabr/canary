local internalNpcName = "Anerui"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 63
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

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am the mistress of the hunt. At this place you may buy the food our hunts provide."})
keywordHandler:addKeyword({'hunt'}, StdModule.say, {npcHandler = npcHandler, text = "Hunting is an art, practiced too often by diletantes. Every fool with a bow or a spear considers himself a hunter."})
keywordHandler:addKeyword({'bow'}, StdModule.say, {npcHandler = npcHandler, text = "Bow, arrow, and spear are the hunters' best friends. In the northeast of the town one of us may sell such tools."})
keywordHandler:addKeyword({'hunter'}, StdModule.say, {npcHandler = npcHandler, text = "Hunters live a life of freedom and closeness to nature, unlike a simple farmer or bugherder."})
keywordHandler:addKeyword({'nature'}, StdModule.say, {npcHandler = npcHandler, text = "Nature is not a friend but an unforgiving teacher, and the lessons we have to learn are endless."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "Watch the sky, it will tell you."})
keywordHandler:addKeyword({'crunor'}, StdModule.say, {npcHandler = npcHandler, text = "I guess it's a human god for the human sight of nature. I have not much knowledge of this entity."})
keywordHandler:addKeyword({'teshial'}, StdModule.say, {npcHandler = npcHandler, text = "If they ever existed they are gone now."})
keywordHandler:addKeyword({'kuridai'}, StdModule.say, {npcHandler = npcHandler, text = "The Kuridai are too agressive not only to people but also to the enviroment. They lack any understanding of the balance that we know as nature."})
keywordHandler:addKeyword({'balance'}, StdModule.say, {npcHandler = npcHandler, text = "The balance of nature, of course. It's everywhere, so don't ask but observe and learn."})
keywordHandler:addKeyword({'deraisim'}, StdModule.say, {npcHandler = npcHandler, text = "We try to live in harmony with the forces of nature, may they be living or unliving."})
keywordHandler:addKeyword({'human'}, StdModule.say, {npcHandler = npcHandler, text = "The humans are a loud and ugly race. They lack any grace and are more kin to the orcs then to us."})
keywordHandler:addKeyword({'death'}, StdModule.say, {npcHandler = npcHandler, text = "Life and death are significant parts of the balance."})
keywordHandler:addKeyword({'life'}, StdModule.say, {npcHandler = npcHandler, text = "Life and death are significant parts of the balance."})
keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = "I despise their presence in our town, but it may be a necessary evil."})
keywordHandler:addKeyword({'elf'}, StdModule.say, {npcHandler = npcHandler, text = "That is the race to which I belong."})
keywordHandler:addKeyword({'cenath'}, StdModule.say, {npcHandler = npcHandler, text = "The magic they wield is all that matters to them."})

-- Greeting message
keywordHandler:addGreetKeyword({"ashari"}, {npcHandler = npcHandler, text = "Ashari, |PLAYERNAME|."})
-- Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"}, {npcHandler = npcHandler, text = "Asha Thrazi."})

npcHandler:setMessage(MESSAGE_GREET, "Ashari |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Asha Thrazi.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Asha Thrazi.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcConfig.shop = {
	{ itemName = "ham", clientId = 3582, buy = 6 },
	{ itemName = "meat", clientId = 3577, buy = 4 }
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
