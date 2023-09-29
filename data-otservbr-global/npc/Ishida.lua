local internalNpcName = "Uryu"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1102,
	lookHead = 114,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
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
        vocation = VOCATION.BASE_ID.PALADIN
    })
end

-- Paladin's Spells Configurations 
local spells = {
    { "arrow call", "Arrow Call", 0, 1 },
    { "cancel invisibility", "Cancel Invisibility", 1600, 26 },
    { "conjure explosive arrow", "Conjure Explosive Arrow", 1000, 25 },
    { "conjure arrow", "Conjure Arrow", 450, 13 },
    { "cure curse", "Cure Curse", 6000, 80 },
    { "cure poison", "Cure Poison", 150, 10 },
    { "divine caldera", "Divine Caldera", 3000, 50 },
    { "divine dazzle", "Divine Dazzle", 250000, 250 },
    { "divine healing", "Divine Healing", 3000, 35 },
    { "divine missile", "Divine Missile", 1800, 40 },
    { "enchant spear", "Enchant Spear", 2000, 45 },
    { "strong ethereal spear", "Strong Ethereal Spear", 10000, 90 },
    { "ethereal spear", "Ethereal Spear", 1100, 23 },
    { "find fiend", "Find Fiend", 1000, 25 },
    { "find person", "Find Person", 80, 8 },
    { "great light", "Great Light", 500, 13 },
    { "haste", "Haste", 600, 14 },
    { "holy flash", "Holy Flash", 7500, 70 },
    { "intense healing", "Intense Healing", 350, 20 },
    { "intense recovery", "Intense Recovery", 10000, 100 },
    { "levitate", "Levitate", 500, 12 },
    { "light healing", "Light Healing", 0, 8 },
    { "light", "Light", 0, 8 },
    { "magic rope", "Magic Rope", 200, 9 },
    { "protect party", "Protect Party", 4000, 32 },
    { "recovery", "Recovery", 4000, 50 },
    { "salvation", "Salvation", 8000, 60 },
    { "sharpshooter", "Sharpshooter", 8000, 60 },
    { "summon paladin familiar", "Summon Paladin Familiar", 50000, 200 },
    { "swift foot", "Swift Foot", 6000, 55 },
    { "destroy field rune", "Destroy Field Rune", 700, 17 },
    { "disintegrate rune", "Disintegrate Rune", 900, 21 },
    { "holy missile rune", "Holy Missile Rune", 1600, 27 },
}

for _, spellInfo in ipairs(spells) do
    addSpellKeyword({ spellInfo[1] }, spellInfo[2], spellInfo[3], spellInfo[4])
end

-- Paladin's Spells List
keywordHandler:addKeyword({ "attack" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have '{Divine Caldera}', '{Divine Missile}', '{Ethereal Spear}', '{Holy Flash}', and '{Strong Ethereal Spear}'.",
})
keywordHandler:addKeyword({ "healing" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have '{Cure Curse}', '{Cure Poison}', '{Divine Healing}', '{Intense Healing}', '{Intense Recovery}', '{Light Healing}', '{Recovery}', and '{Salvation}'.",
})
keywordHandler:addKeyword({ "support" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have '{Cancel Invisibility}', {Divine Dazzle}, '{Find Fiend}', '{Find Person}', '{Great Light}', '{Haste}', {Levitate}, '{Light}', '{Magic Rope}', '{Sharpshooter}', and '{Swift Foot}'.",
})
keywordHandler:addKeyword({ "conjure" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Arrow Call} ,'{Conjure Arrow}', '{Conjure Explosive Arrow}', and '{Enchant Spear}'.",
})
keywordHandler:addKeyword({ "summon" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have '{Summon Paladin Familiar}'.",
})
keywordHandler:addKeyword({ "runes" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have '{Destroy Field Rune}', '{Disintegrate Rune}', and '{Holy Missile Rune}'.",
})
keywordHandler:addKeyword({ "party" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have '{Protect Party}'.",
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