local internalNpcName = "Gutz"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1444,
	lookHead = 114,
	lookBody = 95,
	lookLegs = 75,
	lookFeet = 94,
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


local function addSpellKeyword(spellKeyword, spellName, price, level)
    keywordHandler:addSpellKeyword(spellKeyword, {
        npcHandler = npcHandler,
        spellName = spellName,
        price = price,
        level = level,
        vocation = VOCATION.BASE_ID.KNIGHT
    })
end

-- Knight's Spells Configurations 
local spells = {
    { "annihilation", "Annihilation", 20000, 110 },
    { "brutal strike", "Brutal Strike", 1000, 16 },
    { "fierce berserk", "Fierce Berserk", 7500, 90 },
    { "berserk", "Berserk", 2500, 35 },
    { "front sweep", "Front Sweep", 4000, 70 },
    { "groundshaker", "Groundshaker", 1500, 33 },
    { "inflict wound", "Inflict Wound", 2500, 40 },
    { "whirlwind throw", "Whirlwind Throw", 1500, 28 },
    { "bruise bane", "Bruise Bane", 0, 1 },
    { "cure bleeding", "Cure Bleeding", 2500, 45 },
    { "cure poison", "Cure Poison", 150, 10 },
    { "fair wound cleansing", "Fair Wound Cleansing", 500000, 300 },
    { "intense recovery", "Intense Recovery", 10000, 100 },
    { "intense wound cleansing", "Intense Wound Cleansing", 6000, 80 },
    { "recovery", "Recovery", 4000, 50 },
    { "wound cleansing", "Wound Cleansing", 0, 8 },
    { "train party", "Train Party", 4000, 32 },
    { "summon knight familiar", "Summon Knight Familiar", 50000, 200 },
    { "blood rage", "Blood Rage", 8000, 60 },
    { "chivalrous challenge", "Chivalrous Challenge", 250000, 150 },
    { "challenge", "Challenge", 2000, 20 },
    { "charge", "Charge", 1300, 25 },
    { "find fiend", "Find Fiend", 1000, 25 },
    { "find person", "Find Person", 80, 8 },
    { "great light", "Great Light", 500, 13 },
    { "haste", "Haste", 600, 14 },
    { "levitate", "Levitate", 500, 12 },
    { "light", "Light", 0, 8 },
    { "magic rope", "Magic Rope", 200, 9 },
    { "protector", "Protector", 6000, 55 },
}

for _, spellInfo in ipairs(spells) do
    addSpellKeyword({ spellInfo[1] }, spellInfo[2], spellInfo[3], spellInfo[4])
end

-- Knight's Spells List
keywordHandler:addKeyword({ "attack" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Annihilation}, {Berserk}, {Brutal Strike}, {Fierce Berserk}, {Front Sweep}, {Groundshaker}, {Inflict Wound}, and {Whirlwind Throw}.",
})
keywordHandler:addKeyword({ "healing" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I can teach you {Bruise Bane}, {Cure Bleeding}, {Cure Poison}, {Fair Wound Cleansing}, {Intense Recovery}, {Intense Wound Cleansing}, {Recovery}, and {Wound Cleansing}.",
})
keywordHandler:addKeyword({ "support" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I can teach you {Blood Rage}, {Challenge}, {Charge}, {Chivalrous Challenge}, {Find Fiend}, {Find Person}, {Great Light}, {Haste}, {Levitate}, {Light}, {Magic Rope}, and {Protector}.",
})
keywordHandler:addKeyword({ "summon" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I can teach you {Summon Knight Familiar}.",
})
keywordHandler:addKeyword({ "party" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I can teach you {Train Party}.",
})
keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {Attack}, {Healing}, {Support}, {Conjure}, {Summon}, {Runes} and {Party}. \z
		What kind of spell do you wish to learn?",
})

npcHandler:setMessage(
	MESSAGE_GREET,
	"Welcome, adventurer. Have you come to learn about spells? \z
	Then you are in the right place. I can teach you many useful {spells}."
)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)