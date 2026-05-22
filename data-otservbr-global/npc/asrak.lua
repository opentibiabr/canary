local internalNpcName = "Asrak"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 29,
	lookHead = 10,
	lookBody = 20,
	lookLegs = 30,
	lookFeet = 40,
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

local node1 = keywordHandler:addKeyword({ "arrow call" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {arrow call} magic spell for free?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "arrow call", vocation = { 3, 7 }, price = 0, level = 1 })

local node2 = keywordHandler:addKeyword({ "bruise bane" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {bruise bane} magic spell for free?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "bruise bane", vocation = { 4, 8 }, price = 0, level = 1 })

local node3 = keywordHandler:addKeyword({ "conjure explosive arrow" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {conjure explosive arrow} magic spell for 1000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "conjure explosive arrow", vocation = { 3, 7 }, price = 1000, level = 25 })

local node4 = keywordHandler:addKeyword({ "conjure arrow" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {conjure arrow} magic spell for 450 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "conjure arrow", vocation = { 3, 7 }, price = 450, level = 13 })

local node5 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node6 = keywordHandler:addKeyword({ "destroy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Destroy Field} Rune spell for 700 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "destroy field rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 700, level = 17 })

local node7 = keywordHandler:addKeyword({ "divine healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {divine healing} magic spell for 3000 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "divine healing", vocation = { 3, 7 }, price = 3000, level = 35 })

local node8 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node9 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node10 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node11 = keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense healing} magic spell for 350 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 350, level = 20 })

local node12 = keywordHandler:addKeyword({ "lesser ethereal spear" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {lesser ethereal spear} magic spell for free?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "lesser ethereal spear", vocation = { 3, 7 }, price = 0, level = 1 })

local node13 = keywordHandler:addKeyword({ "lesser front sweep" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {lesser front sweep} magic spell for free?" })
node13:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "lesser front sweep", vocation = { 4, 8 }, price = 0, level = 1 })

local node14 = keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light healing} magic spell for free?" })
node14:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 8 })

local node15 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node15:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

local node16 = keywordHandler:addKeyword({ "magic patch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic patch} magic spell for free?" })
node16:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic patch", vocation = { 1, 2, 3, 5, 6, 7 }, price = 0, level = 1 })

local node17 = keywordHandler:addKeyword({ "wound cleansing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {wound cleansing} magic spell for free?" })
node17:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "wound cleansing", vocation = { 4, 8 }, price = 0, level = 8 })

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I'm the overseer of the pits and a paladin trainer, but I also know some knight spells." })
keywordHandler:addKeyword({ "gladiators" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Those wannabe fighters are weak and most of them are unable to comprehend a higher concept like the Mooh'Tah." })
keywordHandler:addKeyword({ "help" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I teach worthy warriors the way of the knight." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I'm known as Asrak the Ironhoof." })
keywordHandler:addKeyword({ "king", "tibianus" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I pledge no allegiance to any king, be it human or minotaurean." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Your human army might be big but without skills. They are nothing than sheep to be slaughtered." })
keywordHandler:addKeyword({ "general" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "The human generals are like their warriors. They lack the focus to be true warriors." })
keywordHandler:addKeyword({ "dungeon" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "The dungeons of your desires and fears are not only the solely ones you have to fear but also the only ones you have to conquer." })
keywordHandler:addKeyword({ "gods" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "They implanted the rage in us that almost cost our existence. They used us as pawns in wars that were not ours." })
keywordHandler:addKeyword({ "monsters" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Inferior creatures of rage, driven by their primitive urges. They are only useful to test one's skills." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "To rely on magic is like cheating fate. All cheaters will get their just punishment one day, and so will he." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "If it's truly a weapon to slay gods, it might be worth searching for it." })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "The city pays me well and those undisciplined gladiators need my skills and guidance badly." })
keywordHandler:addKeyword({ "mintwallin" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "The city is only a shadow of what we could have accomplished without that curse of rage that the gods bestowed upon us." })
keywordHandler:addKeyword({ "minotaur" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "In the ancient wars we lost many things due to our rage. The only good thing is that we lost our trust in the gods, too." })
keywordHandler:addKeyword({ "mooh'tah" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "The Mooh'Tah teaches control. It provides you with weapon, armor, and shield. It teaches you harmony and focus." })
keywordHandler:addKeyword({ "rage" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Rage is the legacy of Blog, the beast. It is our primary goal to overcome this rage. The Mooh'Tah is our only hope of salvation and perfection." })
keywordHandler:addKeyword({ "harmony" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "There is harmony in everything that is done correctly. If you feel the harmony of an action, you can sing its song." })
keywordHandler:addKeyword({ "song", "sing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Each harmonic action has it own song. If you can sing it, you are in harmony with that action. This is where the minotaurean battle songs come from." })
keywordHandler:addKeyword({ "battlesongs" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Each Mooh'Tah master focuses his skills on the harmony of battle. He is one with the song that he's singing with his voice or at least his heart." })
keywordHandler:addKeyword({ "weapon" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Make your will your weapon, and your enemies will perish." })
keywordHandler:addKeyword({ "armor" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Courage is the only armor that shields you against rage and fear, the greatest dangers you are facing." })
keywordHandler:addKeyword({ "shield" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Your confidence shall be your shield. Nothing can penetrate that defence." })

keywordHandler:addKeyword({ "spells" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I can teach you {healing}, {support}, {conjure} and {runes} spells. I can also tell you which spells are available at your {level}." })
keywordHandler:addKeyword({ "healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Healing spells: {Bruise Bane}, {Cure Poison}, {Divine Healing}, {Intense Healing}, {Light Healing}, {Magic Patch}, {Wound Cleansing}." })
keywordHandler:addKeyword({ "support" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Support spells: {Arrow Call}, {Find Fiend}, {Find Person}, {Great Light}, {Lesser Ethereal Spear}, {Lesser Front Sweep}, {Light}." })
keywordHandler:addKeyword({ "conjure" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Conjure spells: {Conjure Arrow}, {Conjure Explosive Arrow}." })
keywordHandler:addKeyword({ "runes" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Rune spells: {Destroy Field} Rune." })

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I have spells for level {1}, {8}, {10}, {13}, {17}, {20}, {25} and {35}." })

nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Arrow Call} for free, {Bruise Bane} for free, {Lesser Ethereal Spear} for free, {Lesser Front Sweep} for free and {Magic Patch} for free." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Find Person} for 80 gold, {Light} for free, {Light Healing} for free and {Wound Cleansing} for free." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Conjure Arrow} for 450 gold and {Great Light} for 500 gold." })
nodeLevels:addChildKeyword({ "17" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 17 I have {Destroy Field} Rune for 700 gold." })
nodeLevels:addChildKeyword({ "20" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 20 I have {Intense Healing} for 350 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Conjure Explosive Arrow} for 1000 gold and {Find Fiend} for 1000 gold." })
nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Divine Healing} for 3000 gold." })

npcHandler:setMessage(MESSAGE_GREET, "I welcome you, |PLAYERNAME|! If you need paladin or knight spells, you've come to the right place.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May your path be as straight as an arrow.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
