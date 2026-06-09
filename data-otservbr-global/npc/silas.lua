local internalNpcName = "Silas"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 97,
	lookBody = 118,
	lookLegs = 117,
	lookFeet = 97,
	lookAddons = 1,
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

local node1 = keywordHandler:addKeyword({ "summon paladin familiar" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon paladin familiar} magic spell for 50000 gold?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "summon paladin familiar", vocation = { 3, 7 }, price = 50000, level = 200 })

local node2 = keywordHandler:addKeyword({ "strong ethereal spear" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong ethereal spear} magic spell for 10000 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong ethereal spear", vocation = { 3, 7 }, price = 10000, level = 90 })

local node3 = keywordHandler:addKeyword({ "conjure explosive arrow" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {conjure explosive arrow} magic spell for 1000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "conjure explosive arrow", vocation = { 3, 7 }, price = 1000, level = 25 })

local node4 = keywordHandler:addKeyword({ "divine caldera" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {divine caldera} magic spell for 3000 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "divine caldera", vocation = { 3, 7 }, price = 3000, level = 50 })

local node5 = keywordHandler:addKeyword({ "divine healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {divine healing} magic spell for 3000 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "divine healing", vocation = { 3, 7 }, price = 3000, level = 35 })

local node6 = keywordHandler:addKeyword({ "divine missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {divine missile} magic spell for 1800 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "divine missile", vocation = { 3, 7 }, price = 1800, level = 40 })

local node7 = keywordHandler:addKeyword({ "ethereal spear" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ethereal spear} magic spell for 1100 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ethereal spear", vocation = { 3, 7 }, price = 1100, level = 23 })

local node8 = keywordHandler:addKeyword({ "holy flash" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {holy flash} magic spell for 7500 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "holy flash", vocation = { 3, 7 }, price = 7500, level = 70 })

local node9 = keywordHandler:addKeyword({ "intense recovery" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense recovery} magic spell for 10000 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "intense recovery", vocation = { 3, 4, 7, 8 }, price = 10000, level = 100 })

local node10 = keywordHandler:addKeyword({ "salvation" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {salvation} magic spell for 8000 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "salvation", vocation = { 3, 7 }, price = 8000, level = 60 })

local node11 = keywordHandler:addKeyword({ "swift foot" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {swift foot} magic spell for 6000 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "swift foot", vocation = { 3, 7 }, price = 6000, level = 55 })

local node12 = keywordHandler:addKeyword({ "cancel invisibility" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cancel invisibility} magic spell for 1600 gold?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "cancel invisibility", vocation = { 3, 7 }, price = 1600, level = 26 })

local node13 = keywordHandler:addKeyword({ "conjure arrow" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {conjure arrow} magic spell for 450 gold?" })
node13:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "conjure arrow", vocation = { 3, 7 }, price = 450, level = 13 })

local node14 = keywordHandler:addKeyword({ "cure curse" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure curse} magic spell for 6000 gold?" })
node14:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "cure curse", vocation = { 3, 7 }, price = 6000, level = 80 })

local node15 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node15:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node16 = keywordHandler:addKeyword({ "destroy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Destroy Field} Rune spell for 700 gold?" })
node16:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "destroy field rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 700, level = 17 })

local node17 = keywordHandler:addKeyword({ "disintegrate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Disintegrate} Rune spell for 900 gold?" })
node17:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "disintegrate rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 900, level = 21 })

local node18 = keywordHandler:addKeyword({ "enchant spear" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {enchant spear} magic spell for 2000 gold?" })
node18:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "enchant spear", vocation = { 3, 7 }, price = 2000, level = 45 })

local node19 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node19:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node20 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node20:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node21 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node21:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node22 = keywordHandler:addKeyword({ "haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {haste} magic spell for 600 gold?" })
node22:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "haste", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 600, level = 14 })

local node23 = keywordHandler:addKeyword({ "holy missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Holy Missile} Rune spell for 1600 gold?" })
node23:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "holy missile rune", vocation = { 3, 7 }, price = 1600, level = 27 })

local node24 = keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense healing} magic spell for 350 gold?" })
node24:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 350, level = 20 })

local node25 = keywordHandler:addKeyword({ "levitate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {levitate} magic spell for 500 gold?" })
node25:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "levitate", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 12 })

local node26 = keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light healing} magic spell for free?" })
node26:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 8 })

local node27 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node27:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

local node28 = keywordHandler:addKeyword({ "magic patch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic patch} magic spell for free?" })
node28:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic patch", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 1 })

local node29 = keywordHandler:addKeyword({ "magic rope" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic rope} magic spell for 200 gold?" })
node29:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic rope", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 200, level = 9 })

local node30 = keywordHandler:addKeyword({ "recovery" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {recovery} magic spell for 4000 gold?" })
node30:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "recovery", vocation = { 3, 4, 7, 8 }, price = 4000, level = 50 })

local node31 = keywordHandler:addKeyword({ "arrow call" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {arrow call} magic spell for free?" })
node31:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "arrow call", vocation = { 3, 7 }, price = 0, level = 1 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {attack} spells, {healing} spells, {support} spells and spells for {runes}. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "attack" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My attack spells are: {Arrow Call}, {Divine Caldera}, {Divine Missile}, {Ethereal Spear}, {Holy Flash}, {Strong Ethereal Spear} and {Summon Paladin Familiar}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Cure Curse}, {Cure Poison}, {Divine Healing}, {Intense Healing}, {Intense Recovery}, {Light Healing}, {Magic Patch}, {Recovery} and {Salvation}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Cancel Invisibility}, {Conjure Arrow}, {Conjure Explosive Arrow}, {Enchant Spear}, {Find Fiend}, {Find Person}, {Great Light}, {Haste}, {Levitate}, {Light}, {Magic Rope} and {Swift Foot}.",
})

keywordHandler:addKeyword({ "runes" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My rune spells are: {Destroy Field} Rune, {Disintegrate} Rune and {Holy Missile} Rune.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {9}, {10}, {12}, {13}, {14}, {17}, {20}, {21}, {23}, {25}, {26}, {27}, {35}, {40}, {45}, {50}, {55}, {60}, {70}, {80}, {90}, {100} and {200}.",
})

nodeLevels:addChildKeyword({ "200" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 200 I have {Summon Paladin Familiar} for 50000 gold." })
nodeLevels:addChildKeyword({ "100" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 100 I have {Intense Recovery} for 10000 gold." })
nodeLevels:addChildKeyword({ "90" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 90 I have {Strong Ethereal Spear} for 10000 gold." })
nodeLevels:addChildKeyword({ "80" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 80 I have {Cure Curse} for 6000 gold." })
nodeLevels:addChildKeyword({ "70" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 70 I have {Holy Flash} for 7500 gold." })
nodeLevels:addChildKeyword({ "60" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 60 I have {Salvation} for 8000 gold." })
nodeLevels:addChildKeyword({ "55" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 55 I have {Swift Foot} for 6000 gold." })
nodeLevels:addChildKeyword({ "50" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 50 I have {Divine Caldera} for 3000 gold and {Recovery} for 4000 gold." })
nodeLevels:addChildKeyword({ "45" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 45 I have {Enchant Spear} for 2000 gold." })
nodeLevels:addChildKeyword({ "40" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 40 I have {Divine Missile} for 1800 gold." })
nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Divine Healing} for 3000 gold." })
nodeLevels:addChildKeyword({ "27" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 27 I have {Holy Missile} Rune for 1600 gold." })
nodeLevels:addChildKeyword({ "26" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 26 I have {Cancel Invisibility} for 1600 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Conjure Explosive Arrow} for 1000 gold and {Find Fiend} for 1000 gold." })
nodeLevels:addChildKeyword({ "23" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 23 I have {Ethereal Spear} for 1100 gold." })
nodeLevels:addChildKeyword({ "21" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 21 I have {Disintegrate} Rune for 900 gold." })
nodeLevels:addChildKeyword({ "20" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 20 I have {Intense Healing} for 350 gold." })
nodeLevels:addChildKeyword({ "17" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 17 I have {Destroy Field} Rune for 700 gold." })
nodeLevels:addChildKeyword({ "14" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 14 I have {Haste} for 600 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Conjure Arrow} for 450 gold and {Great Light} for 500 gold." })
nodeLevels:addChildKeyword({ "12" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 12 I have {Levitate} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "9" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 9 I have {Magic Rope} for 200 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Find Person} for 80 gold, {Light} for free and {Light Healing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Arrow Call} for free and {Magic Patch} for free." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "bow", clientId = 3350, buy = 400, sell = 100 },
	{ itemName = "crossbow", clientId = 3349, sell = 120 },
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "red quiver", clientId = 35849, buy = 400 },
	{ itemName = "spear", clientId = 3277, buy = 9, sell = 3 },
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
