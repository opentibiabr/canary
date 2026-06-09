local internalNpcName = "Smiley"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 37,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
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

local node1 = keywordHandler:addKeyword({ "apprentice's strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {apprentice's strike} magic spell for free?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "apprentice's strike", vocation = { 1, 2, 5, 6 }, price = 0, level = 8 })

local node2 = keywordHandler:addKeyword({ "avalanche" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Avalanche} Rune spell for 1200 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "avalanche rune", vocation = { 2, 6 }, price = 1200, level = 30 })

local node3 = keywordHandler:addKeyword({ "chameleon" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Chameleon} Rune spell for 1300 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "chameleon rune", vocation = { 2, 6 }, price = 1300, level = 27 })

local node4 = keywordHandler:addKeyword({ "convince creature" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {convince creature} magic spell for 800 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "convince creature", vocation = { 2, 6 }, price = 800, level = 16 })

local node5 = keywordHandler:addKeyword({ "creature illusion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {creature illusion} magic spell for 1000 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "creature illusion", vocation = { 1, 2, 5, 6 }, price = 1000, level = 23 })

local node6 = keywordHandler:addKeyword({ "cure poison rune" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Cure Poison Rune} spell for 600 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison rune", vocation = { 2, 6 }, price = 600, level = 15 })

local node7 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node8 = keywordHandler:addKeyword({ "destroy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Destroy Field} Rune spell for 700 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "destroy field rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 700, level = 17 })

local node9 = keywordHandler:addKeyword({ "energy wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Wall} Rune spell for 2500 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy wall rune", vocation = { 1, 2, 5, 6 }, price = 2500, level = 41 })

local node10 = keywordHandler:addKeyword({ "energy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Field} Rune spell for 700 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy field rune", vocation = { 1, 2, 5, 6 }, price = 700, level = 18 })

local node11 = keywordHandler:addKeyword({ "explosion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Explosion} Rune spell for 1800 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "explosion rune", vocation = { 1, 2, 5, 6 }, price = 1800, level = 31 })

local node12 = keywordHandler:addKeyword({ "fire bomb" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Bomb} Rune spell for 1500 gold?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire bomb rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 27 })

local node13 = keywordHandler:addKeyword({ "fire wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Wall} Rune spell for 2000 gold?" })
node13:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire wall rune", vocation = { 1, 2, 5, 6 }, price = 2000, level = 33 })

local node14 = keywordHandler:addKeyword({ "fire field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Field} Rune spell for 500 gold?" })
node14:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire field rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node15 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node15:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node16 = keywordHandler:addKeyword({ "heavy magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Heavy Magic Missile} Rune spell for 1500 gold?" })
node16:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "heavy magic missile rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 25 })

local node17 = keywordHandler:addKeyword({ "ice wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ice wave} magic spell for 850 gold?" })
node17:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ice wave", vocation = { 2, 6 }, price = 850, level = 18 })

local node18 = keywordHandler:addKeyword({ "intense healing rune" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Intense Healing Rune} spell for 600 gold?" })
node18:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing rune", vocation = { 2, 6 }, price = 600, level = 15 })

local node19 = keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense healing} magic spell for 350 gold?" })
node19:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 350, level = 20 })

local node20 = keywordHandler:addKeyword({ "invisibility" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {invisibility} magic spell for 2000 gold?" })
node20:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "invisibility", vocation = { 1, 2, 5, 6 }, price = 2000, level = 35 })

local node21 = keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light healing} magic spell for free?" })
node21:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 8 })

local node22 = keywordHandler:addKeyword({ "light magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Light Magic Missile} Rune spell for 500 gold?" })
node22:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light magic missile rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node23 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node23:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

local node24 = keywordHandler:addKeyword({ "magic shield" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic shield} magic spell for 450 gold?" })
node24:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic shield", vocation = { 1, 2, 5, 6 }, price = 450, level = 14 })

local node25 = keywordHandler:addKeyword({ "poison wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Wall} Rune spell for 1600 gold?" })
node25:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison wall rune", vocation = { 1, 2, 5, 6 }, price = 1600, level = 29 })

local node26 = keywordHandler:addKeyword({ "poison field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Field} Rune spell for 300 gold?" })
node26:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison field rune", vocation = { 1, 2, 5, 6 }, price = 300, level = 14 })

local node27 = keywordHandler:addKeyword({ "stalagmite" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Stalagmite} Rune spell for 1400 gold?" })
node27:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "stalagmite rune", vocation = { 2, 6 }, price = 1400, level = 24 })

local node28 = keywordHandler:addKeyword({ "summon creature" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon creature} magic spell for 2000 gold?" })
node28:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "summon creature", vocation = { 2, 6 }, price = 2000, level = 25 })

local node29 = keywordHandler:addKeyword({ "terra wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {terra wave} magic spell for 2500 gold?" })
node29:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "terra wave", vocation = { 2, 6 }, price = 2500, level = 38 })

local node30 = keywordHandler:addKeyword({ "ultimate healing rune" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Ultimate Healing Rune} spell for 1500 gold?" })
node30:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate healing rune", vocation = { 2, 6 }, price = 1500, level = 24 })

local node31 = keywordHandler:addKeyword({ "ultimate healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate healing} magic spell for 1000 gold?" })
node31:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate healing", vocation = { 1, 2, 5, 6 }, price = 1000, level = 30 })

local node32 = keywordHandler:addKeyword({ "chill out" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {chill out} magic spell for free?" })
node32:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "chill out", vocation = { 2, 6 }, price = 0, level = 1 })

local node33 = keywordHandler:addKeyword({ "food" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {food} magic spell for 300 gold?" })
node33:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "food", vocation = { 2, 6 }, price = 300, level = 14 })

local node34 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node34:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node35 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node35:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node36 = keywordHandler:addKeyword({ "magic patch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic patch} magic spell for free?" })
node36:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic patch", vocation = { 2, 3, 6, 7 }, price = 0, level = 1 })

local node37 = keywordHandler:addKeyword({ "mud attack" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {mud attack} magic spell for free?" })
node37:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "mud attack", vocation = { 2, 6 }, price = 0, level = 1 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {attack} spells, {healing} spells, {support} spells and spells for {runes}. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "attack" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My attack spells are: {Apprentice's Strike}, {Chill Out}, {Creature Illusion}, {Ice Wave}, {Invisibility}, {Mud Attack} and {Terra Wave}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Cure Poison}, {Intense Healing}, {Light Healing}, {Magic Patch} and {Ultimate Healing}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Convince Creature}, {Find Fiend}, {Find Person}, {Food}, {Great Light}, {Light}, {Magic Shield} and {Summon Creature}.",
})

keywordHandler:addKeyword({ "runes" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My rune spells are: {Avalanche} Rune, {Chameleon} Rune, {Cure Poison Rune}, {Destroy Field} Rune, {Energy Field} Rune, {Energy Wall} Rune, {Explosion} Rune, {Fire Bomb} Rune, {Fire Field} Rune, {Fire Wall} Rune, {Heavy Magic Missile} Rune, {Intense Healing Rune}, {Light Magic Missile} Rune, {Poison Field} Rune, {Poison Wall} Rune, {Stalagmite} Rune and {Ultimate Healing Rune}.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {10}, {13}, {14}, {15}, {16}, {17}, {18}, {20}, {23}, {24}, {25}, {27}, {29}, {30}, {31}, {33}, {35}, {38} and {41}.",
})

nodeLevels:addChildKeyword({ "41" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 41 I have {Energy Wall} Rune for 2500 gold." })
nodeLevels:addChildKeyword({ "38" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 38 I have {Terra Wave} for 2500 gold." })
nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Invisibility} for 2000 gold." })
nodeLevels:addChildKeyword({ "33" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 33 I have {Fire Wall} Rune for 2000 gold." })
nodeLevels:addChildKeyword({ "31" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 31 I have {Explosion} Rune for 1800 gold." })
nodeLevels:addChildKeyword({ "30" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 30 I have {Avalanche} Rune for 1200 gold and {Ultimate Healing} for 1000 gold." })
nodeLevels:addChildKeyword({ "29" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 29 I have {Poison Wall} Rune for 1600 gold." })
nodeLevels:addChildKeyword({ "27" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 27 I have {Chameleon} Rune for 1300 gold and {Fire Bomb} Rune for 1500 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Find Fiend} for 1000 gold, {Heavy Magic Missile} Rune for 1500 gold and {Summon Creature} for 2000 gold." })
nodeLevels:addChildKeyword({ "24" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 24 I have {Stalagmite} Rune for 1400 gold and {Ultimate Healing Rune} for 1500 gold." })
nodeLevels:addChildKeyword({ "23" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 23 I have {Creature Illusion} for 1000 gold." })
nodeLevels:addChildKeyword({ "20" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 20 I have {Intense Healing} for 350 gold." })
nodeLevels:addChildKeyword({ "18" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 18 I have {Energy Field} Rune for 700 gold and {Ice Wave} for 850 gold." })
nodeLevels:addChildKeyword({ "17" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 17 I have {Destroy Field} Rune for 700 gold." })
nodeLevels:addChildKeyword({ "16" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 16 I have {Convince Creature} for 800 gold." })
nodeLevels:addChildKeyword({ "15" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 15 I have {Cure Poison Rune} for 600 gold, {Fire Field} Rune for 500 gold, {Intense Healing Rune} for 600 gold and {Light Magic Missile} Rune for 500 gold." })
nodeLevels:addChildKeyword({ "14" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 14 I have {Food} for 300 gold, {Magic Shield} for 450 gold and {Poison Field} Rune for 300 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Great Light} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Apprentice's Strike} for free, {Find Person} for 80 gold, {Light} for free and {Light Healing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Chill Out} for free, {Magic Patch} for free and {Mud Attack} for free." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
