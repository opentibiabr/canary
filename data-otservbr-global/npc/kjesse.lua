local internalNpcName = "Kjesse"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 154,
	lookHead = 0,
	lookBody = 94,
	lookLegs = 95,
	lookFeet = 114,
	lookAddons = 3,
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

local node1 = keywordHandler:addKeyword({ "summon druid familiar" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon druid familiar} magic spell for 50000 gold?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "summon druid familiar", vocation = { 2, 6 }, price = 50000, level = 200 })

local node2 = keywordHandler:addKeyword({ "nature's embrace" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {nature's embrace} magic spell for 500000 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "nature's embrace", vocation = { 2, 6 }, price = 500000, level = 275 })

local node3 = keywordHandler:addKeyword({ "restoration" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {restoration} magic spell for 500000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "restoration", vocation = { 1, 2, 5, 6 }, price = 500000, level = 300 })

local node4 = keywordHandler:addKeyword({ "strong ice strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong ice strike} magic spell for 6000 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong ice strike", vocation = { 2, 6 }, price = 6000, level = 80 })

local node5 = keywordHandler:addKeyword({ "strong ice wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong ice wave} magic spell for 7500 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong ice wave", vocation = { 2, 6 }, price = 7500, level = 40 })

local node6 = keywordHandler:addKeyword({ "strong terra strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong terra strike} magic spell for 6000 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong terra strike", vocation = { 2, 6 }, price = 6000, level = 70 })

local node7 = keywordHandler:addKeyword({ "strong haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong haste} magic spell for 1300 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "strong haste", vocation = { 1, 2, 5, 6, 9, 10 }, price = 1300, level = 20 })

local node8 = keywordHandler:addKeyword({ "ultimate healing rune" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Ultimate Healing Rune} spell for 1500 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate healing rune", vocation = { 2, 6 }, price = 1500, level = 24 })

local node9 = keywordHandler:addKeyword({ "ultimate healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate healing} magic spell for 1000 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate healing", vocation = { 1, 2, 5, 6 }, price = 1000, level = 30 })

local node10 = keywordHandler:addKeyword({ "ultimate light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate light} magic spell for 1600 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "ultimate light", vocation = { 1, 2, 5, 6 }, price = 1600, level = 26 })

local node11 = keywordHandler:addKeyword({ "intense healing rune" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Intense Healing Rune} spell for 600 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing rune", vocation = { 2, 6 }, price = 600, level = 15 })

local node12 = keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense healing} magic spell for 350 gold?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 350, level = 20 })

local node13 = keywordHandler:addKeyword({ "light magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Light Magic Missile} Rune spell for 500 gold?" })
node13:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light magic missile rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node14 = keywordHandler:addKeyword({ "heavy magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Heavy Magic Missile} Rune spell for 1500 gold?" })
node14:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "heavy magic missile rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 25 })

local node15 = keywordHandler:addKeyword({ "cure poison rune" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Cure Poison Rune} spell for 600 gold?" })
node15:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison rune", vocation = { 2, 6 }, price = 600, level = 15 })

local node16 = keywordHandler:addKeyword({ "cure bleeding" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure bleeding} magic spell for 2500 gold?" })
node16:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "cure bleeding", vocation = { 2, 4, 6, 8 }, price = 2500, level = 45 })

local node17 = keywordHandler:addKeyword({ "cure burning" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure burning} magic spell for 2000 gold?" })
node17:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "cure burning", vocation = { 2, 6 }, price = 2000, level = 30 })

local node18 = keywordHandler:addKeyword({ "cure electrification" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure electrification} magic spell for 1000 gold?" })
node18:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "cure electrification", vocation = { 2, 6 }, price = 1000, level = 22 })

local node19 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node19:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node20 = keywordHandler:addKeyword({ "cancel magic shield" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cancel magic shield} magic spell for 450 gold?" })
node20:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "cancel magic shield", vocation = { 1, 2, 5, 6 }, price = 450, level = 14 })

local node21 = keywordHandler:addKeyword({ "energy wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Wall} Rune spell for 2500 gold?" })
node21:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy wall rune", vocation = { 1, 2, 5, 6 }, price = 2500, level = 41 })

local node22 = keywordHandler:addKeyword({ "energy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Field} Rune spell for 700 gold?" })
node22:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy field rune", vocation = { 1, 2, 5, 6 }, price = 700, level = 18 })

local node23 = keywordHandler:addKeyword({ "energy strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {energy strike} magic spell for 800 gold?" })
node23:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 12 })

local node24 = keywordHandler:addKeyword({ "fire bomb" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Bomb} Rune spell for 1500 gold?" })
node24:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire bomb rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 27 })

local node25 = keywordHandler:addKeyword({ "fire wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Wall} Rune spell for 2000 gold?" })
node25:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire wall rune", vocation = { 1, 2, 5, 6 }, price = 2000, level = 33 })

local node26 = keywordHandler:addKeyword({ "fire field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Field} Rune spell for 500 gold?" })
node26:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire field rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node27 = keywordHandler:addKeyword({ "flame strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {flame strike} magic spell for 800 gold?" })
node27:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "flame strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 8 })

local node28 = keywordHandler:addKeyword({ "poison bomb" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Bomb} Rune spell for 1000 gold?" })
node28:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "poison bomb rune", vocation = { 2, 6 }, price = 1000, level = 25 })

local node29 = keywordHandler:addKeyword({ "poison wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Wall} Rune spell for 1600 gold?" })
node29:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison wall rune", vocation = { 1, 2, 5, 6 }, price = 1600, level = 29 })

local node30 = keywordHandler:addKeyword({ "poison field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Field} Rune spell for 300 gold?" })
node30:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison field rune", vocation = { 1, 2, 5, 6 }, price = 300, level = 14 })

local node31 = keywordHandler:addKeyword({ "stone shower" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Stone Shower} Rune spell for 1100 gold?" })
node31:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "stone shower rune", vocation = { 2, 6 }, price = 1100, level = 28 })

local node32 = keywordHandler:addKeyword({ "soulfire" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Soulfire} Rune spell for 1800 gold?" })
node32:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "soulfire rune", vocation = { 1, 2, 5, 6 }, price = 1800, level = 27 })

local node33 = keywordHandler:addKeyword({ "stalagmite" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Stalagmite} Rune spell for 1400 gold?" })
node33:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "stalagmite rune", vocation = { 1, 2, 5, 6 }, price = 1400, level = 24 })

local node34 = keywordHandler:addKeyword({ "icicle" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Icicle} Rune spell for 1700 gold?" })
node34:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "icicle rune", vocation = { 2, 6 }, price = 1700, level = 28 })

local node35 = keywordHandler:addKeyword({ "avalanche" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Avalanche} Rune spell for 1200 gold?" })
node35:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "avalanche rune", vocation = { 2, 6 }, price = 1200, level = 30 })

local node36 = keywordHandler:addKeyword({ "explosion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Explosion} Rune spell for 1800 gold?" })
node36:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "explosion rune", vocation = { 1, 2, 5, 6 }, price = 1800, level = 31 })

local node37 = keywordHandler:addKeyword({ "disintegrate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Disintegrate} Rune spell for 900 gold?" })
node37:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "disintegrate rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 900, level = 21 })

local node38 = keywordHandler:addKeyword({ "destroy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Destroy Field} Rune spell for 700 gold?" })
node38:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "destroy field rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 700, level = 17 })

local node39 = keywordHandler:addKeyword({ "paralyse" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Paralyse} Rune spell for 1900 gold?" })
node39:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "paralyse rune", vocation = { 2, 6 }, price = 1900, level = 54 })

local node40 = keywordHandler:addKeyword({ "animate dead" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {animate dead} magic spell for 1200 gold?" })
node40:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "animate dead rune", vocation = { 1, 2, 5, 6 }, price = 1200, level = 27 })

local node41 = keywordHandler:addKeyword({ "chameleon" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Chameleon} Rune spell for 1300 gold?" })
node41:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "chameleon rune", vocation = { 2, 6 }, price = 1300, level = 27 })

local node42 = keywordHandler:addKeyword({ "convince creature" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {convince creature} magic spell for 800 gold?" })
node42:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "convince creature", vocation = { 2, 6 }, price = 800, level = 16 })

local node43 = keywordHandler:addKeyword({ "creature illusion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {creature illusion} magic spell for 1000 gold?" })
node43:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "creature illusion", vocation = { 1, 2, 5, 6 }, price = 1000, level = 23 })

local node44 = keywordHandler:addKeyword({ "envenom" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {envenom} magic spell for 6000 gold?" })
node44:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "envenom", vocation = { 2, 6 }, price = 6000, level = 50 })

local node45 = keywordHandler:addKeyword({ "food" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {food} magic spell for 300 gold?" })
node45:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "food", vocation = { 2, 6 }, price = 300, level = 14 })

local node46 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node46:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node47 = keywordHandler:addKeyword({ "heal friend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {heal friend} magic spell for 800 gold?" })
node47:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "heal friend", vocation = { 2, 6 }, price = 800, level = 18 })

local node48 = keywordHandler:addKeyword({ "ice strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ice strike} magic spell for 800 gold?" })
node48:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ice strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 8 })

local node49 = keywordHandler:addKeyword({ "ice wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ice wave} magic spell for 850 gold?" })
node49:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ice wave", vocation = { 2, 6 }, price = 850, level = 18 })

local node50 = keywordHandler:addKeyword({ "invisible" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {invisible} magic spell for 2000 gold?" })
node50:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "invisible", vocation = { 1, 2, 5, 6 }, price = 2000, level = 35 })

local node51 = keywordHandler:addKeyword({ "mass healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {mass healing} magic spell for 2200 gold?" })
node51:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "mass healing", vocation = { 2, 6 }, price = 2200, level = 36 })

local node52 = keywordHandler:addKeyword({ "physical strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {physical strike} magic spell for 800 gold?" })
node52:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "physical strike", vocation = { 2, 6 }, price = 800, level = 16 })

local node53 = keywordHandler:addKeyword({ "summon creature" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon creature} magic spell for 2000 gold?" })
node53:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "summon creature", vocation = { 1, 2, 5, 6 }, price = 2000, level = 25 })

local node54 = keywordHandler:addKeyword({ "terra strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {terra strike} magic spell for 800 gold?" })
node54:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "terra strike", vocation = { 1, 2, 5, 6 }, price = 800, level = 13 })

local node55 = keywordHandler:addKeyword({ "terra wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {terra wave} magic spell for 2500 gold?" })
node55:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "terra wave", vocation = { 2, 6 }, price = 2500, level = 38 })

local node56 = keywordHandler:addKeyword({ "apprentice's strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {apprentice's strike} magic spell for free?" })
node56:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "apprentice's strike", vocation = { 1, 2, 5, 6 }, price = 0, level = 6 })

local node57 = keywordHandler:addKeyword({ "chill out" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {chill out} magic spell for free?" })
node57:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "chill out", vocation = { 2, 6 }, price = 0, level = 1 })

local node58 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node58:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node59 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node59:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node60 = keywordHandler:addKeyword({ "haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {haste} magic spell for 600 gold?" })
node60:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "haste", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 600, level = 14 })

local node61 = keywordHandler:addKeyword({ "levitate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {levitate} magic spell for 500 gold?" })
node61:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "levitate", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 12 })

local node62 = keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light healing} magic spell for free?" })
node62:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 8 })

local node63 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node63:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

local node64 = keywordHandler:addKeyword({ "magic patch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic patch} magic spell for free?" })
node64:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic patch", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 1 })

local node65 = keywordHandler:addKeyword({ "magic rope" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic rope} magic spell for 200 gold?" })
node65:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic rope", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 200, level = 9 })

local node66 = keywordHandler:addKeyword({ "magic shield" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic shield} magic spell for 450 gold?" })
node66:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = true, spellName = "magic shield", vocation = { 1, 2, 5, 6 }, price = 450, level = 14 })

local node67 = keywordHandler:addKeyword({ "mud attack" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {mud attack} magic spell for free?" })
node67:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "mud attack", vocation = { 2, 6 }, price = 0, level = 1 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {attack} spells, {healing} spells, {support} spells and spells for {runes}. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "attack" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My attack spells are: {Apprentice's Strike}, {Chill Out}, {Creature Illusion}, {Energy Strike}, {Envenom}, {Flame Strike}, {Ice Strike}, {Ice Wave}, {Mud Attack}, {Physical Strike}, {Strong Ice Strike}, {Strong Ice Wave}, {Strong Terra Strike}, {Terra Strike} and {Terra Wave}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Cure Bleeding}, {Cure Burning}, {Cure Electrification}, {Cure Poison}, {Heal Friend}, {Intense Healing}, {Light Healing}, {Magic Patch}, {Mass Healing}, {Nature's Embrace}, {Restoration} and {Ultimate Healing}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Animate Dead}, {Cancel Magic Shield}, {Convince Creature}, {Find Fiend}, {Find Person}, {Food}, {Great Light}, {Haste}, {Invisible}, {Levitate}, {Light}, {Magic Rope}, {Magic Shield}, {Strong Haste}, {Summon Creature}, {Summon Druid Familiar} and {Ultimate Light}.",
})

keywordHandler:addKeyword({ "runes" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My rune spells are: {Avalanche} Rune, {Chameleon} Rune, {Cure Poison Rune}, {Destroy Field} Rune, {Disintegrate} Rune, {Energy Field} Rune, {Energy Wall} Rune, {Explosion} Rune, {Fire Bomb} Rune, {Fire Field} Rune, {Fire Wall} Rune, {Heavy Magic Missile} Rune, {Icicle} Rune, {Intense Healing Rune}, {Light Magic Missile} Rune, {Paralyse} Rune, {Poison Bomb} Rune, {Poison Field} Rune, {Poison Wall} Rune, {Soulfire} Rune, {Stalagmite} Rune, {Stone Shower} Rune and {Ultimate Healing Rune}.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {9}, {10}, {12}, {13}, {14}, {15}, {16}, {17}, {18}, {20}, {21}, {22}, {23}, {24}, {25}, {26}, {27}, {28}, {29}, {30}, {31}, {33}, {35}, {36}, {38}, {40}, {41}, {45}, {50}, {54}, {70}, {80}, {200} and {300}.",
})

nodeLevels:addChildKeyword({ "300" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 300 I have {Nature's Embrace} for 500000 gold and {Restoration} for 500000 gold." })
nodeLevels:addChildKeyword({ "200" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 200 I have {Summon Druid Familiar} for 50000 gold." })
nodeLevels:addChildKeyword({ "80" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 80 I have {Strong Ice Strike} for 6000 gold." })
nodeLevels:addChildKeyword({ "70" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 70 I have {Strong Terra Strike} for 6000 gold." })
nodeLevels:addChildKeyword({ "54" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 54 I have {Paralyse} Rune for 1900 gold." })
nodeLevels:addChildKeyword({ "50" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 50 I have {Envenom} for 6000 gold." })
nodeLevels:addChildKeyword({ "45" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 45 I have {Cure Bleeding} for 2500 gold." })
nodeLevels:addChildKeyword({ "41" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 41 I have {Energy Wall} Rune for 2500 gold." })
nodeLevels:addChildKeyword({ "40" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 40 I have {Strong Ice Wave} for 7500 gold." })
nodeLevels:addChildKeyword({ "38" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 38 I have {Terra Wave} for 2500 gold." })
nodeLevels:addChildKeyword({ "36" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 36 I have {Mass Healing} for 2200 gold." })
nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Invisible} for 2000 gold." })
nodeLevels:addChildKeyword({ "33" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 33 I have {Fire Wall} Rune for 2000 gold." })
nodeLevels:addChildKeyword({ "31" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 31 I have {Explosion} Rune for 1800 gold." })
nodeLevels:addChildKeyword({ "30" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 30 I have {Avalanche} Rune for 1200 gold, {Cure Burning} for 2000 gold and {Ultimate Healing} for 1000 gold." })
nodeLevels:addChildKeyword({ "29" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 29 I have {Poison Wall} Rune for 1600 gold." })
nodeLevels:addChildKeyword({ "28" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 28 I have {Icicle} Rune for 1700 gold and {Stone Shower} Rune for 1100 gold." })
nodeLevels:addChildKeyword({ "27" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 27 I have {Animate Dead} for 1200 gold, {Chameleon} Rune for 1300 gold, {Fire Bomb} Rune for 1500 gold and {Soulfire} Rune for 1800 gold." })
nodeLevels:addChildKeyword({ "26" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 26 I have {Ultimate Light} for 1600 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Find Fiend} for 1000 gold, {Heavy Magic Missile} Rune for 1500 gold, {Poison Bomb} Rune for 1000 gold and {Summon Creature} for 2000 gold." })
nodeLevels:addChildKeyword({ "24" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 24 I have {Stalagmite} Rune for 1400 gold and {Ultimate Healing Rune} for 1500 gold." })
nodeLevels:addChildKeyword({ "23" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 23 I have {Creature Illusion} for 1000 gold." })
nodeLevels:addChildKeyword({ "22" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 22 I have {Cure Electrification} for 1000 gold." })
nodeLevels:addChildKeyword({ "21" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 21 I have {Disintegrate} Rune for 900 gold." })
nodeLevels:addChildKeyword({ "20" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 20 I have {Intense Healing} for 350 gold and {Strong Haste} for 1300 gold." })
nodeLevels:addChildKeyword({ "18" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 18 I have {Energy Field} Rune for 700 gold, {Heal Friend} for 800 gold and {Ice Wave} for 850 gold." })
nodeLevels:addChildKeyword({ "17" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 17 I have {Destroy Field} Rune for 700 gold." })
nodeLevels:addChildKeyword({ "16" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 16 I have {Convince Creature} for 800 gold and {Physical Strike} for 800 gold." })
nodeLevels:addChildKeyword({ "15" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 15 I have {Cure Poison Rune} for 600 gold, {Fire Field} Rune for 500 gold, {Ice Strike} for 800 gold, {Intense Healing Rune} for 600 gold and {Light Magic Missile} Rune for 500 gold." })
nodeLevels:addChildKeyword({ "14" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 14 I have {Cancel Magic Shield} for 450 gold, {Flame Strike} for 800 gold, {Food} for 300 gold, {Haste} for 600 gold, {Magic Shield} for 450 gold and {Poison Field} Rune for 300 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Great Light} for 500 gold and {Terra Strike} for 800 gold." })
nodeLevels:addChildKeyword({ "12" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 12 I have {Energy Strike} for 800 gold and {Levitate} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "9" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 9 I have {Magic Rope} for 200 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Apprentice's Strike} for free, {Find Person} for 80 gold, {Light} for free and {Light Healing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Chill Out} for free, {Magic Patch} for free and {Mud Attack} for free." })

-- Twist of Fate
local blessKeyword = keywordHandler:addKeyword({ "twist of fate" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"This is a special blessing I can bestow upon you once you have obtained at least one of the other blessings and which functions a bit differently. ...",
		"It only works when you're killed by other adventurers, which means that at least half of the damage leading to your death was caused by others, not by monsters or the environment. ...",
		"The {twist of fate} will not reduce the death penalty like the other blessings, but instead prevent you from losing your other blessings as well as the amulet of loss, should you wear one. It costs the same as the other blessings. ...",
		"Would you like to receive that protection for a sacrifice of |PVPBLESSCOST| gold, child?",
	},
})
blessKeyword:addChildKeyword({ "yes" }, StdModule.bless, { npcHandler = npcHandler, text = "So receive the protection of the twist of fate, pilgrim.", cost = "|PVPBLESSCOST|", bless = 1 })
blessKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "Fine. You are free to decline my offer.", reset = true })

-- Adventurer Stone
keywordHandler:addKeyword({ "adventurer stone" }, StdModule.say, { npcHandler = npcHandler, text = "Keep your adventurer's stone well." }, function(player)
	return player:getItemById(16277, true)
end)

local stoneKeyword = keywordHandler:addKeyword({ "adventurer stone" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, you want to replace your adventurer's stone for free?" }, function(player)
	return player:getStorageValue(Storage.Quest.U9_80.AdventurersGuild.FreeStone.Kjesse) ~= 1
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, nil, function(player)
	player:addItem(16277, 1)
	player:setStorageValue(Storage.Quest.U9_80.AdventurersGuild.FreeStone.Kjesse, 1)
end)
stoneKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "No problem.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "adventurer stone" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, you want to replace your adventurer's stone for 30 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 30
end, function(player)
	if player:removeMoneyBank(30) then
		player:addItem(16277, 1)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })
stoneKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "No problem.", reset = true })

-- Healing
local function addHealKeyword(text, condition, effect)
	keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = text }, function(player)
		return player:getCondition(condition) ~= nil
	end, function(player)
		player:removeCondition(condition)
		player:getPosition():sendMagicEffect(effect)
	end)
end

addHealKeyword("You are burning. Let me quench those flames.", CONDITION_FIRE, CONST_ME_MAGIC_GREEN)
addHealKeyword("You are poisoned. Let me soothe your pain.", CONDITION_POISON, CONST_ME_MAGIC_RED)
addHealKeyword("You are electrified, my child. Let me help you to stop trembling.", CONDITION_ENERGY, CONST_ME_MAGIC_GREEN)

keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = "You are hurt, my child. I will heal your wounds." }, function(player)
	return player:getHealth() < 40
end, function(player)
	local health = player:getHealth()
	if health < 40 then
		player:addHealth(40 - health)
	end
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
end)
keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = "You aren't looking that bad. Sorry, I can't help you. But if you are looking for additional protection you should go on the {pilgrimage} of ashes or get the protection of the {twist of fate} here." })

-- Basic
keywordHandler:addKeyword({ "pilgrimage" }, StdModule.say, { npcHandler = npcHandler, text = "Whenever you receive a lethal wound, your vital force is damaged and there is a chance that you lose some of your equipment. With every single of the five {blessings} you have, this damage and chance of loss will be reduced." })
keywordHandler:addKeyword({ "blessings" }, StdModule.say, { npcHandler = npcHandler, text = "There are five blessings available in five sacred places: the {spiritual} shielding, the spark of the {phoenix}, the {embrace} of Tibia, the fire of the {suns} and the wisdom of {solitude}. Additionally, you can receive the {twist of fate} here." })
keywordHandler:addKeyword({ "spiritual" }, StdModule.say, { npcHandler = npcHandler, text = "I see you received the spiritual shielding in the whiteflower temple south of Thais." }, function(player)
	return player:hasBlessing(1)
end)
keywordHandler:addAliasKeyword({ "shield" })
keywordHandler:addKeyword({ "embrace" }, StdModule.say, { npcHandler = npcHandler, text = "I can sense that the druids north of Carlin have provided you with the Embrace of Tibia." }, function(player)
	return player:hasBlessing(2)
end)
keywordHandler:addKeyword({ "suns" }, StdModule.say, { npcHandler = npcHandler, text = "I can see you received the blessing of the two suns in the suntower near Ab'Dendriel." }, function(player)
	return player:hasBlessing(3)
end)
keywordHandler:addAliasKeyword({ "fire" })
keywordHandler:addKeyword({ "phoenix" }, StdModule.say, { npcHandler = npcHandler, text = "I can sense that the spark of the phoenix already was given to you by the dwarven priests of earth and fire in Kazordoon." }, function(player)
	return player:hasBlessing(4)
end)
keywordHandler:addAliasKeyword({ "spark" })
keywordHandler:addKeyword({ "solitude" }, StdModule.say, { npcHandler = npcHandler, text = "I can sense you already talked to the hermit Eremo on the isle of Cormaya and received this blessing." }, function(player)
	return player:hasBlessing(5)
end)
keywordHandler:addAliasKeyword({ "wisdom" })
keywordHandler:addKeyword({ "spiritual" }, StdModule.say, { npcHandler = npcHandler, text = "You can ask for the blessing of spiritual shielding in the whiteflower temple south of Thais." })
keywordHandler:addAliasKeyword({ "shield" })
keywordHandler:addKeyword({ "embrace" }, StdModule.say, { npcHandler = npcHandler, text = "The druids north of Carlin will provide you with the embrace of Tibia." })
keywordHandler:addKeyword({ "suns" }, StdModule.say, { npcHandler = npcHandler, text = "You can ask for the blessing of the two suns in the suntower near Ab'Dendriel." })
keywordHandler:addAliasKeyword({ "fire" })
keywordHandler:addKeyword({ "phoenix" }, StdModule.say, { npcHandler = npcHandler, text = "The spark of the phoenix is given by the dwarven priests of earth and fire in Kazordoon." })
keywordHandler:addAliasKeyword({ "spark" })
keywordHandler:addKeyword({ "solitude" }, StdModule.say, { npcHandler = npcHandler, text = "Talk to the hermit Eremo on the isle of Cormaya about this blessing." })
keywordHandler:addAliasKeyword({ "wisdom" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome, young |PLAYERNAME|! If you are heavily wounded or poisoned, I can {heal} you for free.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Remember: If you are heavily wounded or poisoned, I can heal you for free.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May the gods bless you, |PLAYERNAME|!")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
