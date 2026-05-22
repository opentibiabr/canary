local internalNpcName = "Garamond"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 432,
	lookHead = 0,
	lookBody = 113,
	lookLegs = 109,
	lookFeet = 107,
	lookAddons = 2,
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

local lightMagicMissileNode = keywordHandler:addKeyword({ "light magic missile" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {light magic missile} magic spell for 500 gold?",
})
lightMagicMissileNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Light Magic Missile",
	vocation = { 1, 2, 5, 6 },
	price = 500,
	level = 15,
})

local apprenticeStrikeNode = keywordHandler:addKeyword({ "apprentice's strike" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {apprentice's strike} magic spell for free?",
})
apprenticeStrikeNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Apprentice's Strike",
	vocation = { 1, 2, 5, 6 },
	price = 0,
	level = 8,
})

local physicalStrikeNode = keywordHandler:addKeyword({ "physical strike" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {physical strike} magic spell for 800?",
})
physicalStrikeNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Physical Strike",
	vocation = { 2, 6 },
	price = 800,
	level = 16,
})

local deathStrikeNode = keywordHandler:addKeyword({ "death strike" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {death strike} magic spell for 800 gold?",
})
deathStrikeNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Death Strike",
	vocation = { 1, 5 },
	price = 800,
	level = 16,
})

local energyStrikeNode = keywordHandler:addKeyword({ "energy strike" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {energy strike} magic spell for 800 gold?",
})
energyStrikeNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Energy Strike",
	vocation = { 1, 2, 5, 6 },
	price = 800,
	level = 12,
})

local terraStrikeNode = keywordHandler:addKeyword({ "terra strike" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {terra strike} magic spell for 800 gold?",
})
terraStrikeNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Terra Strike",
	vocation = { 1, 2, 5, 6 },
	price = 800,
	level = 13,
})

local flameStrikeNode = keywordHandler:addKeyword({ "flame strike" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {flame strike} magic spell for 800 gold?",
})
flameStrikeNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Flame Strike",
	vocation = { 1, 2, 5, 6 },
	price = 800,
	level = 14,
})

local iceStrikeNode = keywordHandler:addKeyword({ "ice strike" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {ice strike} magic spell for 800 gold?",
})
iceStrikeNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Ice Strike",
	vocation = { 1, 2, 5, 6 },
	price = 800,
	level = 15,
})

local poisonFieldNode = keywordHandler:addKeyword({ "poison field" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {poison field} magic spell for 300 gold?",
})
poisonFieldNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Poison Field",
	vocation = { 1, 2, 5, 6 },
	price = 300,
	level = 14,
})

local fireFieldNode = keywordHandler:addKeyword({ "fire field" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {fire field} magic spell for 500 gold?",
})
fireFieldNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Fire Field",
	vocation = { 1, 2, 5, 6 },
	price = 500,
	level = 15,
})

local energyFieldNode = keywordHandler:addKeyword({ "energy field" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {energy field} magic spell for 700 gold?",
})
energyFieldNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Energy Field",
	vocation = { 1, 2, 5, 6 },
	price = 700,
	level = 18,
})

local iceWaveNode = keywordHandler:addKeyword({ "ice wave" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {ice wave} magic spell for 850 gold?",
})
iceWaveNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Ice Wave",
	vocation = { 2, 6 },
	price = 850,
	level = 18,
})

local curePoisonNode = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {cure poison} magic spell for 150 gold?",
})
curePoisonNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Cure Poison",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 150,
	level = 10,
})

local magicRopeNode = keywordHandler:addKeyword({ "magic rope" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {magic rope} magic spell for 200 gold?",
})
magicRopeNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Magic Rope",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 200,
	level = 9,
})

local findPersonNode = keywordHandler:addKeyword({ "find person" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {find person} magic spell for 80 gold?",
})
findPersonNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Find Person",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 80,
	level = 8,
})

local greatLightNode = keywordHandler:addKeyword({ "great light" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {great light} magic spell for 500 gold?",
})
greatLightNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Great Light",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 500,
	level = 13,
})

local lightHealingNode = keywordHandler:addKeyword({ "light healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {light healing} magic spell for free?",
})
lightHealingNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Light Healing",
	vocation = { 1, 2, 3, 5, 6, 7, 9, 10 },
	price = 0,
	level = 8,
})

local levitateNode = keywordHandler:addKeyword({ "levitate" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {levitate} magic spell for 500 gold?",
})
levitateNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Levitate",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 500,
	level = 12,
})

local hasteNode = keywordHandler:addKeyword({ "haste" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {haste} magic spell for 600 gold?",
})
hasteNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Haste",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 600,
	level = 14,
})

local lightNode = keywordHandler:addKeyword({ "light" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {light} magic spell for free?",
})
lightNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "Light",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 0,
	level = 8,
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, { npcHandler = npcHandler, text = "In this category I have '{light healing}' and '{cure poison}'." })
keywordHandler:addKeyword({ "support" }, StdModule.say, { npcHandler = npcHandler, text = "In this category I have '{find person}', '{magic rope}', '{levitate}', '{light}', '{great light}', '{haste}', '{poison field}', '{fire field}', '{light magic missile}' and '{energy field}'." })
keywordHandler:addKeyword({ "attack" }, StdModule.say, { npcHandler = npcHandler, text = "In this category I have '{death strike}', '{apprentice's strike}', '{energy strike}', '{terra strike}', '{flame strike}', '{ice strike}', '{physical strike}', '{ice wave}'." })
keywordHandler:addKeyword({ "spell" }, StdModule.say, { npcHandler = npcHandler, text = "I can teach you {healing spells}, {support spells} and {attack spells}. What kind of spell do you wish to learn?" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Garamond Starstream." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Did you not listen? I am the teacher of druid and sorcerer spells for level 8 to 18. I teach young adventurers spells they can use once they have the proper vocation - druid or sorcerer." })
keywordHandler:addKeyword({ "rookgaard" }, StdModule.say, { npcHandler = npcHandler, text = "I have an old friend there. Haven't heard from him in a while." })
keywordHandler:addKeyword({ "dawnport" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, it's not too bad here, believe me. At least I always get young and enthusiast disciples! Though I must confess I miss the vastness of the Tibian plains. <sighs>" })
keywordHandler:addKeyword({ "inigo" }, StdModule.say, { npcHandler = npcHandler, text = "A kind old hunter. He loves to see young life around, taking on the ways and lays of the land. If you have any question, ask Inigo for help." })
keywordHandler:addKeyword({ "coltrayne" }, StdModule.say, { npcHandler = npcHandler, text = "Roughened and toughened by life's tragedies. A good man, but somber." })
keywordHandler:addKeyword({ "garamond" }, StdModule.say, { npcHandler = npcHandler, text = "Yes, child. If you wish to learn a spell, tell me." })
keywordHandler:addKeyword({ "hamish" }, StdModule.say, { npcHandler = npcHandler, text = "A very headstrong young man, though I appreciate his devotion to the craft of potion-making. No respect for senior authority or age at all! Except maybe for a little soft spot for Mr Morris." })
keywordHandler:addKeyword({ "mr morris" }, StdModule.say, { npcHandler = npcHandler, text = "A strange young man. He seems driven, to my mind. By what force, I do not know. I take it the world needs adventurers such as him." })
keywordHandler:addKeyword({ "plunderpurse" }, StdModule.say, { npcHandler = npcHandler, text = "Redeeming one's soul by becoming a clerk? Not very likely. Once a pirate, always a pirate. But he's a charming old rogue." })
keywordHandler:addKeyword({ "richard" }, StdModule.say, { npcHandler = npcHandler, text = "Not a half bad cook, truly. Must have been that squirrel diet, it seems to have lead him to discover a new cuisine - everything to forget the bad taste of squirrels, he said." })
keywordHandler:addKeyword({ "ser tybald" }, StdModule.say, { npcHandler = npcHandler, text = "He is proficient in the martial arts. A very skilled teacher of spells for knights and paladins. If that is your vocation, you should talk to Ser Tybald." })
keywordHandler:addKeyword({ "wentworth" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, yes. Travelled with Plunderpurse a lot as I recall. Captain Plunderpurse, then. Got his head full of numbers and statistics, that boy." })
keywordHandler:addKeyword({ "magic" }, StdModule.say, { npcHandler = npcHandler, text = "Each vocation has their own unique spells to enhance their fighting or defense, which none of the other vocations can use, and which you can only learn at a spell trainer of your vocation." })
keywordHandler:addKeyword({ "main" }, StdModule.say, { npcHandler = npcHandler, text = "Most of the major cities are on the Tibian mainland, such as the rich merchant city of Venore, for example. You will find spell teachers for your vocation in almost every major city." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "Tibia is the world we live in. Rookgaard is not far off from the Tibian {mainland}, though it's a tricky passage with contrary winds. On the mainland, you will find more adventure, mystery and monsters and can prove yourself a hero or villain." })
keywordHandler:addKeyword({ "oressa" }, StdModule.say, { npcHandler = npcHandler, text = "A very intelligent girl. Prefers to listen to wild animals' noises instead of humans', which is quite understandable when you think about it. However, she's also a very apt healer and can give you advice on your choice of vocation." })
keywordHandler:addKeyword({ "vocation" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Your choice of vocation will determine your life in Tibia, and the skills and fighting techniques you may use. There are four vocation: knight, druid, paladin and sorcerer. If you want to know more about them, talk to Oressa in the temple. I myself teach try-out spells for both the magical classes, whereas Tybald in the next room specialises in knight and paladin spells.",
})
keywordHandler:addKeyword({ "menesto" }, StdModule.say, { npcHandler = npcHandler, text = "Very young and sometimes precipitate, burning for everything mystical, holy, godly, which is not a bad thing as such. Just a little hasty and prone to fall into a nest of monsters now and then, but he always comes out alive." })
keywordHandler:addKeyword({ "key" }, StdModule.say, { npcHandler = npcHandler, text = "How should I know where that key has gotten to? I rarely sleep at my age anyway! Though I must say that my young adventurer fellows handled it quite carelessly, from what I saw." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome, child. Have you come to learn about {magic}? Then you are in the right place. I can teach you many useful {spells}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Go and be careful. Remember what you have learned!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Take care, |PLAYERNAME|.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
