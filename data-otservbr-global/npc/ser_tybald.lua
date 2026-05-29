local internalNpcName = "Ser Tybald"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 134,
	lookHead = 97,
	lookBody = 19,
	lookLegs = 60,
	lookFeet = 115,
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

local woundNode = keywordHandler:addKeyword({ "wound cleansing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {wound cleansing} magic spell for free?",
})
woundNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "wound cleansing",
	vocation = { 4, 8 },
	price = 0,
	level = 8,
})

local brutalNode = keywordHandler:addKeyword({ "brutal strike" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {brutal strike} magic spell for 1000 gold?",
})
brutalNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "brutal strike",
	vocation = { 4, 8 },
	price = 1000,
	level = 16,
})

local cureNode = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {cure poison} magic spell for 150 gold?",
})
cureNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "cure poison",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 150,
	level = 10,
})

local greatLightNode = keywordHandler:addKeyword({ "great light" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {great light} magic spell for 500 gold?",
})
greatLightNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "great light",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 500,
	level = 13,
})

local findPersonNode = keywordHandler:addKeyword({ "find person" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {find person} magic spell for 80 gold?",
})
findPersonNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "find person",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 80,
	level = 8,
})

local magicRopeNode = keywordHandler:addKeyword({ "magic rope" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {magic rope} magic spell for 200 gold?",
})
magicRopeNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "magic rope",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 200,
	level = 9,
})

local lightHealingNode = keywordHandler:addKeyword({ "light healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {light healing} magic spell for free?",
})
lightHealingNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "light healing",
	vocation = { 1, 2, 3, 5, 6, 7, 9, 10 },
	price = 0,
	level = 8,
})

local conjureArrowNode = keywordHandler:addKeyword({ "conjure arrow" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {conjure arrow} magic spell for 450 gold?",
})
conjureArrowNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "conjure arrow",
	vocation = { 3, 7 },
	price = 450,
	level = 13,
})

local levitateNode = keywordHandler:addKeyword({ "levitate" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "Would you like to learn {levitate} magic spell for 500 gold?",
})
levitateNode:addChildKeyword({ "yes" }, StdModule.learnSpell, {
	npcHandler = npcHandler,
	premium = false,
	spellName = "levitate",
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
	spellName = "haste",
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
	spellName = "light",
	vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 },
	price = 0,
	level = 8,
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, { npcHandler = npcHandler, text = "In this category I have '{Light healing}', '{Wound cleansing}', and '{Cure poison}'." })
keywordHandler:addKeyword({ "support" }, StdModule.say, { npcHandler = npcHandler, text = "In this category I have '{Find person}', '{Magic Rope}', '{Levitate}', '{Light}', '{Great Light}', and '{Haste}'." })
keywordHandler:addKeyword({ "attack" }, StdModule.say, { npcHandler = npcHandler, text = "In this category I have '{Brutal strike}' for knights." })
keywordHandler:addKeyword({ "conjure" }, StdModule.say, { npcHandler = npcHandler, text = "In this category I have '{Conjure Arrow}' for paladins." })
keywordHandler:addKeyword({ "spell" }, StdModule.say, { npcHandler = npcHandler, text = "I can teach you {healing spells}, {support spells}, {conjure spells} and {attack spells}. What kind of spell do you wish to learn?" })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Ser Tybald. <bows courteously>." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm just an adventurer looking for action. Learn from the best! Just ask me about knight and paladin {spells}." })
keywordHandler:addKeyword({ "dawnport" }, StdModule.say, { npcHandler = npcHandler, text = "From afar, the island glowed at midnight as if dawn was at hand. A fierce magical light, beckoning, calling out, promising power past redemption - but I am sure {Garamond} has a better idea as to the exact nature of that magical power." })
keywordHandler:addKeyword({ "inigo" }, StdModule.say, { npcHandler = npcHandler, text = "He's a mentor to all young adventurers. If you have a question as to what you should or could do, and how this world works, talk to Inigo, he will be happy to help." })
keywordHandler:addKeyword({ "coltrayne" }, StdModule.say, { npcHandler = npcHandler, text = "Now there is someone who has had his share of grief. No wonder he came to {Dawnport} to assist raising new heroes for the {Tibian} lands." })
keywordHandler:addKeyword({ "garamond" }, StdModule.say, { npcHandler = npcHandler, text = "Is that old man still teaching magic spells?" })
keywordHandler:addKeyword({ "mr morris" }, StdModule.say, { npcHandler = npcHandler, text = "We know each other from old, yes. Will we talk about it? No." })
keywordHandler:addKeyword({ "plunderpurse" }, StdModule.say, { npcHandler = npcHandler, text = "That old pirate has settled down now it seems." })
keywordHandler:addKeyword({ "richard" }, StdModule.say, { npcHandler = npcHandler, text = "He's quite a good cook, which helps improve the mood on bad days. He's a carpenter by trade. Did a good job reinforcing this outpost, too." })
keywordHandler:addKeyword({ "ser tybald" }, StdModule.say, { npcHandler = npcHandler, text = "It used to be a kind of title in other times, but it serves nicely as a first name here." })
keywordHandler:addKeyword({ "magic" }, StdModule.say, { npcHandler = npcHandler, text = "Each vocation has their own unique spells to enhance their fighting or defense, which none of the other vocations can use, and which you can only learn at a spell trainer of your vocation." })
keywordHandler:addKeyword({ "main" }, StdModule.say, { npcHandler = npcHandler, text = "Most of the major cities are on the Tibian mainland, such as the rich merchant city of Venore, for example. You will find spell teachers for your vocation in almost every major city." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "Tibia is the world we live in. Rookgaard is not far off from the Tibian {mainland}, though it's a tricky passage with contrary winds. On the mainland, you will find more adventure, mystery and monsters and can prove yourself a hero or villain." })
keywordHandler:addKeyword({ "oressa" }, StdModule.say, { npcHandler = npcHandler, text = "What a beautiful lady. Do you know the Lay of the White Lady Illadria? ... 'Calm and slender like a birch, soft and white like snow, yet strong and warm like the sun she is.' Well, it fits perfectly. I am her sworn protector." })
keywordHandler:addKeyword({ "menesto" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, still so young and naive about the gods and demons... Still, I envy him his unspoilt beliefs. If I could turn back time... but never mind my ramblings." })
keywordHandler:addKeyword({ "key" }, StdModule.say, { npcHandler = npcHandler, text = "Mr Morris has much on his mind and may have been somewhat distracted with regard to that key. He probably just misplaced it, somewhere on top of all those archeological findings he stores." })

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, young adventurer.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Always stay upwind, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "A go-getter. I like that.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
