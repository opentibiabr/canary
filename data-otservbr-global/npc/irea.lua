local internalNpcName = "Irea"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 64,
}

npcConfig.flags = {
	floorchange = false,
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

-- Greeting message
keywordHandler:addGreetKeyword({ "ashari" }, { npcHandler = npcHandler, text = "Greetings, |PLAYERNAME|." })
--Farewell message
keywordHandler:addFarewellKeyword({ "asgha thrazi" }, { npcHandler = npcHandler, text = "Goodbye, |PLAYERNAME|." })

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye!")

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

local node1 = keywordHandler:addKeyword({ "conjure explosive arrow" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {conjure explosive arrow} magic spell for 1000 gold?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "conjure explosive arrow", vocation = { 3, 7 }, price = 1000, level = 25 })

local node2 = keywordHandler:addKeyword({ "conjure arrow" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {conjure arrow} magic spell for 450 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "conjure arrow", vocation = { 3, 7 }, price = 450, level = 13 })

local node3 = keywordHandler:addKeyword({ "divine healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {divine healing} magic spell for 3000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "divine healing", vocation = { 3, 7 }, price = 3000, level = 35 })

local node4 = keywordHandler:addKeyword({ "lesser ethereal spear" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {lesser ethereal spear} magic spell for free?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "lesser ethereal spear", vocation = { 3, 7 }, price = 0, level = 1 })

local node5 = keywordHandler:addKeyword({ "arrow call" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {arrow call} magic spell for free?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "arrow call", vocation = { 3, 7 }, price = 0, level = 1 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {attack} spells, {healing} spells and {support} spells. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "attack" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My attack spell is: {Lesser Ethereal Spear}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Divine Healing}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Arrow Call}, {Conjure Arrow} and {Conjure Explosive Arrow}.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {13}, {25} and {35}.",
})

nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Divine Healing} for 3000 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Conjure Explosive Arrow} for 1000 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Conjure Arrow} for 450 gold." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Arrow Call} for free and {Lesser Ethereal Spear} for free." })

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
