local internalNpcName = "Galuna"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 137,
	lookHead = 40,
	lookBody = 96,
	lookLegs = 95,
	lookFeet = 96,
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
	{ text = "Bows, crossbows and ammunition on special sale today." },
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

npcHandler:setMessage(MESSAGE_GREET, "Oh, please come in, |PLAYERNAME|. What do you need? Distance weapons? I sell lots of them.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye.")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "the first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "If you'd ask me - what you just did - it's only a myth." })
keywordHandler:addKeyword({ "crossbows" }, StdModule.say, { npcHandler = npcHandler, text = "I don't buy used crossbows. If you want to buy one, just ask me for a trade." })
keywordHandler:addKeyword({ "fletcher" }, StdModule.say, { npcHandler = npcHandler, text = "I am the local fletcher. I am selling bows, crossbows, and ammunition. Do you need anything?" })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "I heard about him." })
keywordHandler:addKeyword({ "paladin" }, StdModule.say, { npcHandler = npcHandler, text = "We are feared warriors and good marksmen. Ask Elane if want to know more about the guild." })
keywordHandler:addKeyword({ "forest" }, StdModule.say, { npcHandler = npcHandler, text = "Tibia, a green island. Here it is wunderful to walk into the forests and to hunt with a bow." })
keywordHandler:addKeyword({ "arrows" }, StdModule.say, { npcHandler = npcHandler, text = "I sell arrows for bows and bolts for crossbows. Ask me for a trade if you're interested to see my wares." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "She is the leader of all paladins." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "Tibia, a green island. Here it is wunderful to walk into the forests and to hunt with a bow." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "We have visitors of all kind in Thais, only elves show up seldom." })
keywordHandler:addKeyword({ "elves" }, StdModule.say, { npcHandler = npcHandler, text = "It is rumored that they live in the northeast of Tibia. They are the best in archery." })
keywordHandler:addKeyword({ "bolts" }, StdModule.say, { npcHandler = npcHandler, text = "I sell arrows for bows and bolts for crossbows. Ask me for a trade if you're interested to see my wares." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Galuna, paladin and fletcher." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Don't bother me. Go and buy a watch." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "I supplied him with my goods in the past, now I sell them myself." })
keywordHandler:addKeyword({ "bows" }, StdModule.say, { npcHandler = npcHandler, text = "I don't buy used bows. If you want to buy one, just ask me for a trade." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the local fletcher. I am selling bows, crossbows, and ammunition. Do you need anything?" })
keywordHandler:addKeyword({ "elf" }, StdModule.say, { npcHandler = npcHandler, text = "It is rumored that they live in the northeast of Tibia. They are the best in archery." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "bow", clientId = 3350, buy = 400 },
	{ itemName = "crossbow", clientId = 3349, buy = 500 },
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "red quiver", clientId = 35849, buy = 400 },
	{ itemName = "spear", clientId = 3277, buy = 10 },
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
