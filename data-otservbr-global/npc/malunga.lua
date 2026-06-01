local internalNpcName = "Malunga"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 149,
	lookHead = 95,
	lookBody = 78,
	lookLegs = 19,
	lookFeet = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "<mumble>" },
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

local node1 = keywordHandler:addKeyword({ "summon sorcerer familiar" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon sorcerer familiar} magic spell for 50000 gold?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "summon sorcerer familiar", vocation = { 1, 5 }, price = 50000, level = 200 })

local node2 = keywordHandler:addKeyword({ "restoration" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {restoration} magic spell for 500000 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "restoration", vocation = { 1, 2, 5, 6 }, price = 500000, level = 300 })

local node3 = keywordHandler:addKeyword({ "expose weakness" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {expose weakness} magic spell for 400000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "expose weakness", vocation = { 1, 5 }, price = 400000, level = 275 })

local node4 = keywordHandler:addKeyword({ "sap strength" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {sap strength} magic spell for 200000 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "sap strength", vocation = { 1, 5 }, price = 200000, level = 175 })

local node5 = keywordHandler:addKeyword({ "strong energy strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong energy strike} magic spell for 7500 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong energy strike", vocation = { 1, 5 }, price = 7500, level = 80 })

local node6 = keywordHandler:addKeyword({ "strong flame strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong flame strike} magic spell for 6000 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong flame strike", vocation = { 1, 5 }, price = 6000, level = 70 })

local node7 = keywordHandler:addKeyword({ "strong haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong haste} magic spell for 1300 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong haste", vocation = { 1, 2, 5, 6, 9, 10 }, price = 1300, level = 20 })

local node8 = keywordHandler:addKeyword({ "great energy beam" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great energy beam} magic spell for 1800 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great energy beam", vocation = { 1, 5 }, price = 1800, level = 29 })

local node9 = keywordHandler:addKeyword({ "great fire wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great fire wave} magic spell for 25000 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "great fire wave", vocation = { 1, 5 }, price = 25000, level = 38 })

local node10 = keywordHandler:addKeyword({ "great fireball" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Great Fireball} Rune spell for 1200 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great fireball rune", vocation = { 1, 5 }, price = 1200, level = 30 })

local node11 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node12 = keywordHandler:addKeyword({ "ultimate light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate light} magic spell for 1600 gold?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "ultimate light", vocation = { 1, 2, 5, 6 }, price = 1600, level = 26 })

local node13 = keywordHandler:addKeyword({ "ultimate healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate healing} magic spell for 1000 gold?" })
node13:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate healing", vocation = { 1, 2, 5, 6 }, price = 1000, level = 30 })

local node14 = keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense healing} magic spell for 350 gold?" })
node14:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 350, level = 20 })

local node15 = keywordHandler:addKeyword({ "light magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Light Magic Missile} Rune spell for 500 gold?" })
node15:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light magic missile rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node16 = keywordHandler:addKeyword({ "heavy magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Heavy Magic Missile} Rune spell for 1500 gold?" })
node16:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "heavy magic missile rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 25 })

local node17 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node17:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node18 = keywordHandler:addKeyword({ "cancel magic shield" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cancel magic shield} magic spell for 450 gold?" })
node18:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "cancel magic shield", vocation = { 1, 2, 5, 6 }, price = 450, level = 14 })

local node19 = keywordHandler:addKeyword({ "magic wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Magic Wall} Rune spell for 2100 gold?" })
node19:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "magic wall rune", vocation = { 1, 5 }, price = 2100, level = 32 })

local node20 = keywordHandler:addKeyword({ "magic shield" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic shield} magic spell for 450 gold?" })
node20:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "magic shield", vocation = { 1, 2, 5, 6 }, price = 450, level = 14 })

local node21 = keywordHandler:addKeyword({ "magic rope" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic rope} magic spell for 200 gold?" })
node21:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic rope", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 200, level = 9 })

local node22 = keywordHandler:addKeyword({ "magic patch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic patch} magic spell for free?" })
node22:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic patch", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 1 })

local node23 = keywordHandler:addKeyword({ "summon creature" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon creature} magic spell for 2000 gold?" })
node23:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "summon creature", vocation = { 1, 2, 5, 6 }, price = 2000, level = 25 })

local node24 = keywordHandler:addKeyword({ "energy bomb" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Bomb} Rune spell for 2300 gold?" })
node24:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "energy bomb rune", vocation = { 1, 5 }, price = 2300, level = 37 })

local node25 = keywordHandler:addKeyword({ "energy wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Wall} Rune spell for 2500 gold?" })
node25:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy wall rune", vocation = { 1, 2, 5, 6 }, price = 2500, level = 41 })

local node26 = keywordHandler:addKeyword({ "energy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Field} Rune spell for 700 gold?" })
node26:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy field rune", vocation = { 1, 2, 5, 6 }, price = 700, level = 18 })

local node27 = keywordHandler:addKeyword({ "energy wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {energy wave} magic spell for 2500 gold?" })
node27:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy wave", vocation = { 1, 5 }, price = 2500, level = 38 })

local node28 = keywordHandler:addKeyword({ "energy beam" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {energy beam} magic spell for 1000 gold?" })
node28:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy beam", vocation = { 1, 5 }, price = 1000, level = 23 })

local node29 = keywordHandler:addKeyword({ "energy strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {energy strike} magic spell for 800 gold?" })
node29:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 12 })

local node30 = keywordHandler:addKeyword({ "fire bomb" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Bomb} Rune spell for 1500 gold?" })
node30:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire bomb rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 27 })

local node31 = keywordHandler:addKeyword({ "fire wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Wall} Rune spell for 2000 gold?" })
node31:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire wall rune", vocation = { 1, 2, 5, 6 }, price = 2000, level = 33 })

local node32 = keywordHandler:addKeyword({ "fire field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Field} Rune spell for 500 gold?" })
node32:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire field rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node33 = keywordHandler:addKeyword({ "fire wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {fire wave} magic spell for 850 gold?" })
node33:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire wave", vocation = { 1, 5 }, price = 850, level = 18 })

local node34 = keywordHandler:addKeyword({ "fireball" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fireball} Rune spell for 1600 gold?" })
node34:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "fireball rune", vocation = { 1, 5 }, price = 1600, level = 27 })

local node35 = keywordHandler:addKeyword({ "flame strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {flame strike} magic spell for 800 gold?" })
node35:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "flame strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 8 })

local node36 = keywordHandler:addKeyword({ "poison wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Wall} Rune spell for 1600 gold?" })
node36:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison wall rune", vocation = { 1, 2, 5, 6 }, price = 1600, level = 29 })

local node37 = keywordHandler:addKeyword({ "poison field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Field} Rune spell for 300 gold?" })
node37:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison field rune", vocation = { 1, 2, 5, 6 }, price = 300, level = 14 })

local node38 = keywordHandler:addKeyword({ "soulfire" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Soulfire} Rune spell for 1800 gold?" })
node38:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "soulfire rune", vocation = { 1, 2, 5, 6 }, price = 1800, level = 27 })

local node39 = keywordHandler:addKeyword({ "stalagmite" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Stalagmite} Rune spell for 1400 gold?" })
node39:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "stalagmite rune", vocation = { 1, 2, 5, 6 }, price = 1400, level = 24 })

local node40 = keywordHandler:addKeyword({ "thunderstorm" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Thunderstorm} Rune spell for 1100 gold?" })
node40:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "thunderstorm rune", vocation = { 1, 5 }, price = 1100, level = 28 })

local node41 = keywordHandler:addKeyword({ "explosion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Explosion} Rune spell for 1800 gold?" })
node41:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "explosion rune", vocation = { 1, 2, 5, 6 }, price = 1800, level = 31 })

local node42 = keywordHandler:addKeyword({ "disintegrate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Disintegrate} Rune spell for 900 gold?" })
node42:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "disintegrate rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 900, level = 21 })

local node43 = keywordHandler:addKeyword({ "destroy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Destroy Field} Rune spell for 700 gold?" })
node43:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "destroy field rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 700, level = 17 })

local node44 = keywordHandler:addKeyword({ "animate dead" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {animate dead} magic spell for 1200 gold?" })
node44:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "animate dead rune", vocation = { 1, 2, 5, 6 }, price = 1200, level = 27 })

local node45 = keywordHandler:addKeyword({ "creature illusion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {creature illusion} magic spell for 1000 gold?" })
node45:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "creature illusion", vocation = { 1, 2, 5, 6 }, price = 1000, level = 23 })

local node46 = keywordHandler:addKeyword({ "curse" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {curse} magic spell for 6000 gold?" })
node46:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "curse", vocation = { 1, 5 }, price = 6000, level = 75 })

local node47 = keywordHandler:addKeyword({ "death strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {death strike} magic spell for 800 gold?" })
node47:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "death strike", vocation = { 1, 5 }, price = 800, level = 16 })

local node48 = keywordHandler:addKeyword({ "electrify" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {electrify} magic spell for 2500 gold?" })
node48:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "electrify", vocation = { 1, 5 }, price = 2500, level = 34 })

local node49 = keywordHandler:addKeyword({ "ice strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ice strike} magic spell for 800 gold?" })
node49:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ice strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 8 })

local node50 = keywordHandler:addKeyword({ "ignite" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ignite} magic spell for 1500 gold?" })
node50:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "ignite", vocation = { 1, 5 }, price = 1500, level = 26 })

local node51 = keywordHandler:addKeyword({ "invisible" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {invisible} magic spell for 2000 gold?" })
node51:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "invisible", vocation = { 1, 2, 5, 6 }, price = 2000, level = 35 })

local node52 = keywordHandler:addKeyword({ "lightning" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {lightning} magic spell for 5000 gold?" })
node52:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "lightning", vocation = { 1, 5 }, price = 5000, level = 55 })

local node53 = keywordHandler:addKeyword({ "sudden death" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Sudden Death} Rune spell for 3000 gold?" })
node53:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "sudden death rune", vocation = { 1, 5 }, price = 3000, level = 45 })

local node54 = keywordHandler:addKeyword({ "terra strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {terra strike} magic spell for 800 gold?" })
node54:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "terra strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 13 })

local node55 = keywordHandler:addKeyword({ "apprentice's strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {apprentice's strike} magic spell for free?" })
node55:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "apprentice's strike", vocation = { 1, 2, 5, 6 }, price = 0, level = 6 })

local node56 = keywordHandler:addKeyword({ "buzz" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {buzz} magic spell for free?" })
node56:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "buzz", vocation = { 1, 5 }, price = 0, level = 1 })

local node57 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node57:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node58 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node58:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node59 = keywordHandler:addKeyword({ "haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {haste} magic spell for 600 gold?" })
node59:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "haste", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 600, level = 14 })

local node60 = keywordHandler:addKeyword({ "levitate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {levitate} magic spell for 500 gold?" })
node60:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "levitate", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 12 })

local node61 = keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light healing} magic spell for free?" })
node61:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 8 })

local node62 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node62:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

local node63 = keywordHandler:addKeyword({ "scorch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {scorch} magic spell for free?" })
node63:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "scorch", vocation = { 1, 5 }, price = 0, level = 1 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {attack} spells, {healing} spells, {support} spells and spells for {runes}. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "attack" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My attack spells are: {Apprentice's Strike}, {Buzz}, {Creature Illusion}, {Curse}, {Death Strike}, {Electrify}, {Energy Beam}, {Energy Strike}, {Energy Wave}, {Fire Wave}, {Flame Strike}, {Great Energy Beam}, {Great Fire Wave}, {Ice Strike}, {Ignite}, {Invisible}, {Lightning}, {Scorch}, {Strong Energy Strike}, {Strong Flame Strike} and {Terra Strike}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Cure Poison}, {Intense Healing}, {Light Healing}, {Magic Patch}, {Restoration} and {Ultimate Healing}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Animate Dead}, {Cancel Magic Shield}, {Find Fiend}, {Find Person}, {Great Light}, {Haste}, {Levitate}, {Light}, {Magic Rope}, {Magic Shield}, {Strong Haste}, {Summon Creature}, {Summon Sorcerer Familiar} and {Ultimate Light}.",
})

keywordHandler:addKeyword({ "runes" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My rune spells are: {Destroy Field} Rune, {Disintegrate} Rune, {Energy Bomb} Rune, {Energy Field} Rune, {Energy Wall} Rune, {Explosion} Rune, {Fire Bomb} Rune, {Fire Field} Rune, {Fire Wall} Rune, {Fireball} Rune, {Great Fireball} Rune, {Heavy Magic Missile} Rune, {Light Magic Missile} Rune, {Poison Field} Rune, {Poison Wall} Rune, {Soulfire} Rune, {Stalagmite} Rune, {Sudden Death} Rune and {Thunderstorm} Rune.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {9}, {10}, {12}, {13}, {14}, {15}, {16}, {17}, {18}, {20}, {21}, {23}, {24}, {25}, {26}, {27}, {28}, {29}, {30}, {31}, {32}, {33}, {34}, {35}, {37}, {38}, {41}, {45}, {55}, {70}, {75}, {80}, {175}, {200}, {275} and {300}.",
})

nodeLevels:addChildKeyword({ "300" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 300 I have {Restoration} for 500000 gold." })
nodeLevels:addChildKeyword({ "275" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 275 I have {Expose Weakness} for 400000 gold." })
nodeLevels:addChildKeyword({ "200" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 200 I have {Summon Sorcerer Familiar} for 50000 gold." })
nodeLevels:addChildKeyword({ "175" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 175 I have {Sap Strength} for 200000 gold." })
nodeLevels:addChildKeyword({ "80" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 80 I have {Strong Energy Strike} for 7500 gold." })
nodeLevels:addChildKeyword({ "75" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 75 I have {Curse} for 6000 gold." })
nodeLevels:addChildKeyword({ "70" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 70 I have {Strong Flame Strike} for 6000 gold." })
nodeLevels:addChildKeyword({ "55" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 55 I have {Lightning} for 5000 gold." })
nodeLevels:addChildKeyword({ "45" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 45 I have {Sudden Death} Rune for 3000 gold." })
nodeLevels:addChildKeyword({ "41" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 41 I have {Energy Wall} Rune for 2500 gold." })
nodeLevels:addChildKeyword({ "38" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 38 I have {Energy Wave} for 2500 gold and {Great Fire Wave} for 25000 gold." })
nodeLevels:addChildKeyword({ "37" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 37 I have {Energy Bomb} Rune for 2300 gold." })
nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Invisible} for 2000 gold." })
nodeLevels:addChildKeyword({ "34" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 34 I have {Electrify} for 2500 gold." })
nodeLevels:addChildKeyword({ "33" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 33 I have {Fire Wall} Rune for 2000 gold." })
nodeLevels:addChildKeyword({ "32" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 32 I have {Magic Wall} Rune for 2100 gold." })
nodeLevels:addChildKeyword({ "31" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 31 I have {Explosion} Rune for 1800 gold." })
nodeLevels:addChildKeyword({ "30" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 30 I have {Great Fireball} Rune for 1200 gold and {Ultimate Healing} for 1000 gold." })
nodeLevels:addChildKeyword({ "29" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 29 I have {Great Energy Beam} for 1800 gold and {Poison Wall} Rune for 1600 gold." })
nodeLevels:addChildKeyword({ "28" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 28 I have {Thunderstorm} Rune for 1100 gold." })
nodeLevels:addChildKeyword({ "27" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 27 I have {Animate Dead} for 1200 gold, {Fire Bomb} Rune for 1500 gold, {Fireball} Rune for 1600 gold and {Soulfire} Rune for 1800 gold." })
nodeLevels:addChildKeyword({ "26" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 26 I have {Ignite} for 1500 gold and {Ultimate Light} for 1600 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Find Fiend} for 1000 gold, {Heavy Magic Missile} Rune for 1500 gold and {Summon Creature} for 2000 gold." })
nodeLevels:addChildKeyword({ "24" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 24 I have {Stalagmite} Rune for 1400 gold." })
nodeLevels:addChildKeyword({ "23" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 23 I have {Creature Illusion} for 1000 gold and {Energy Beam} for 1000 gold." })
nodeLevels:addChildKeyword({ "21" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 21 I have {Disintegrate} Rune for 900 gold." })
nodeLevels:addChildKeyword({ "20" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 20 I have {Intense Healing} for 350 gold and {Strong Haste} for 1300 gold." })
nodeLevels:addChildKeyword({ "18" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 18 I have {Energy Field} Rune for 700 gold and {Fire Wave} for 850 gold." })
nodeLevels:addChildKeyword({ "17" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 17 I have {Destroy Field} Rune for 700 gold." })
nodeLevels:addChildKeyword({ "16" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 16 I have {Death Strike} for 800 gold." })
nodeLevels:addChildKeyword({ "15" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 15 I have {Fire Field} Rune for 500 gold, {Ice Strike} for 800 gold and {Light Magic Missile} Rune for 500 gold." })
nodeLevels:addChildKeyword({ "14" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 14 I have {Cancel Magic Shield} for 450 gold, {Flame Strike} for 800 gold, {Haste} for 600 gold, {Magic Shield} for 450 gold and {Poison Field} Rune for 300 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Great Light} for 500 gold and {Terra Strike} for 800 gold." })
nodeLevels:addChildKeyword({ "12" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 12 I have {Energy Strike} for 800 gold and {Levitate} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "9" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 9 I have {Magic Rope} for 200 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Apprentice's Strike} for free, {Find Person} for 80 gold, {Light} for free and {Light Healing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Buzz} for free, {Magic Patch} for free and {Scorch} for free." })

npcHandler:setMessage(MESSAGE_GREET, "Greetings. I have only little time to {spare}, so the conversation will be short. I teach sorcerer {spells} and buy a few magical {ingredients}.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "boggy dreads", clientId = 9667, sell = 200 },
	{ itemName = "bonecarving knife", clientId = 17830, sell = 140 },
	{ itemName = "centipede leg", clientId = 10301, sell = 28 },
	{ itemName = "cliff strider claw", clientId = 16134, sell = 800 },
	{ itemName = "cobra tongue", clientId = 9634, sell = 15 },
	{ itemName = "compound eye", clientId = 14083, sell = 150 },
	{ itemName = "crawler head plating", clientId = 14079, sell = 210 },
	{ itemName = "damselfly eye", clientId = 17463, sell = 25 },
	{ itemName = "damselfly wing", clientId = 17458, sell = 20 },
	{ itemName = "deepling breaktime snack", clientId = 14011, sell = 90 },
	{ itemName = "deepling claw", clientId = 14044, sell = 430 },
	{ itemName = "deepling ridge", clientId = 14041, sell = 360 },
	{ itemName = "deepling scales", clientId = 14017, sell = 80 },
	{ itemName = "deepling warts", clientId = 14012, sell = 180 },
	{ itemName = "demonic finger", clientId = 12541, sell = 1000 },
	{ itemName = "dowser", clientId = 19110, sell = 35 },
	{ itemName = "essence of a bad dream", clientId = 10306, sell = 360 },
	{ itemName = "eye of a deepling", clientId = 12730, sell = 150 },
	{ itemName = "eye of a weeper", clientId = 16132, sell = 650 },
	{ itemName = "eye of corruption", clientId = 11671, sell = 390 },
	{ itemName = "fir cone", clientId = 19111, sell = 25 },
	{ itemName = "ghastly dragon head", clientId = 10449, sell = 700 },
	{ itemName = "ghoul snack", clientId = 11467, sell = 60 },
	{ itemName = "gland", clientId = 8143, sell = 500 },
	{ itemName = "hair of a banshee", clientId = 11446, sell = 350 },
	{ itemName = "half-digested piece of meat", clientId = 10283, sell = 55 },
	{ itemName = "half-eaten brain", clientId = 9659, sell = 85 },
	{ itemName = "hatched rorc egg", clientId = 18997, sell = 30 },
	{ itemName = "haunted piece of wood", clientId = 9683, sell = 115 },
	{ itemName = "hellhound slobber", clientId = 9637, sell = 500 },
	{ itemName = "horoscope", clientId = 18926, sell = 40 },
	{ itemName = "incantation notes", clientId = 18929, sell = 90 },
	{ itemName = "lancet", clientId = 18925, sell = 90 },
	{ itemName = "lizard essence", clientId = 11680, sell = 300 },
	{ itemName = "mutated flesh", clientId = 10308, sell = 50 },
	{ itemName = "mutated rat tail", clientId = 9668, sell = 150 },
	{ itemName = "necromantic robe", clientId = 11475, sell = 250 },
	{ itemName = "pelvis bone", clientId = 11481, sell = 30 },
	{ itemName = "petrified scream", clientId = 10420, sell = 250 },
	{ itemName = "piece of dead brain", clientId = 9663, sell = 420 },
	{ itemName = "piece of scarab shell", clientId = 9641, sell = 45 },
	{ itemName = "piece of swampling wood", clientId = 17823, sell = 30 },
	{ itemName = "pieces of magic chalk", clientId = 18930, sell = 210 },
	{ itemName = "pig foot", clientId = 9693, sell = 10 },
	{ itemName = "pile of grave earth", clientId = 11484, sell = 25 },
	{ itemName = "poison spider shell", clientId = 11485, sell = 10 },
	{ itemName = "poisonous slime", clientId = 9640, sell = 50 },
	{ itemName = "rorc egg", clientId = 18996, sell = 120 },
	{ itemName = "rotten piece of cloth", clientId = 10291, sell = 30 },
	{ itemName = "scale of corruption", clientId = 11673, sell = 680 },
	{ itemName = "scorpion tail", clientId = 9651, sell = 25 },
	{ itemName = "slime mould", clientId = 12601, sell = 175 },
	{ itemName = "small pitchfork", clientId = 11513, sell = 70 },
	{ itemName = "spider fangs", clientId = 8031, sell = 10 },
	{ itemName = "spidris mandible", clientId = 14082, sell = 450 },
	{ itemName = "spitter nose", clientId = 14078, sell = 340 },
	{ itemName = "strand of medusa hair", clientId = 10309, sell = 600 },
	{ itemName = "swampling moss", clientId = 17822, sell = 20 },
	{ itemName = "swarmer antenna", clientId = 14076, sell = 130 },
	{ itemName = "tail of corruption", clientId = 11672, sell = 240 },
	{ itemName = "tarantula egg", clientId = 10281, sell = 80 },
	{ itemName = "tentacle piece", clientId = 11666, sell = 5000 },
	{ itemName = "thorn", clientId = 9643, sell = 100 },
	{ itemName = "tooth file", clientId = 18924, sell = 60 },
	{ itemName = "undead heart", clientId = 10450, sell = 200 },
	{ itemName = "vampire's cape chain", clientId = 18927, sell = 150 },
	{ itemName = "venison", clientId = 18995, sell = 55 },
	{ itemName = "waspoid claw", clientId = 14080, sell = 320 },
	{ itemName = "waspoid wing", clientId = 14081, sell = 190 },
	{ itemName = "widow's mandibles", clientId = 10411, sell = 110 },
	{ itemName = "winged tail", clientId = 10313, sell = 800 },
	{ itemName = "yielocks", clientId = 12805, sell = 600 },
	{ itemName = "yielowax", clientId = 12742, sell = 600 },
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
