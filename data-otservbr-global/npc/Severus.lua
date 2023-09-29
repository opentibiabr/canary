local internalNpcName = "Severus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1436,
	lookHead = 114,
	lookBody = 95,
	lookLegs = 114,
	lookFeet = 114,
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
        vocation = VOCATION.BASE_ID.SORCERER
    })
end

-- Sorcerer's Spells Configurations 
-- Criação da tabela spells com os dados da primeira tabela
local spells = {
    { "ultimate energy strike", "Ultimate Energy Strike", 15000, 100 },
    { "ultimate flame strike", "Ultimate Flame Strike", 15000, 90 },
    { "ultimate healing", "Ultimate Healing", 1000, 30 },
    { "ultimate light", "Ultimate Light", 1600, 26 },
    { "apprentice's strike", "Apprentice's Strike", 0, 8 },
    { "buzz", "Buzz", 0, 1 },
    { "cancel magic shield", "Cancel Magic Shield", 450, 14 },
    { "conjure wand of darkness", "Conjure Wand of Darkness", 5000, 41 },
    { "creature illusion", "Creature Illusion", 1000, 23 },
    { "cure poison", "Cure Poison", 150, 10 },
    { "curse", "Curse", 6000, 75 },
    { "great energy beam", "Great Energy Beam", 1800, 29 },
    { "great fire wave", "Great Fire Wave", 25000, 38 },
    { "great light", "Great Light", 500, 13 },
    { "electrify", "Electrify", 2500, 34 },
    { "enchant party", "Enchant Party", 4000, 32 },
    { "energy beam", "Energy Beam", 1000, 23 },
    { "energy wave", "Energy Wave", 2500, 38 },
    { "expose weakness", "Expose Weakness", 400000, 275 },
    { "find fiend", "Find Fiend", 1000, 25 },
    { "find person", "Find Person", 80, 8 },
    { "fire wave", "Fire Wave", 850, 18 },
    { "hell's core", "Hell's Core", 8000, 60 },
    { "strong haste", "Strong Haste", 1300, 20 },
    { "ignite", "Ignite", 1500, 26 },
    { "intense healing", "Intense Healing", 350, 20 },
    { "invisible", "Invisible", 2000, 35 },
    { "levitate", "Levitate", 500, 12 },
    { "light healing", "Light Healing", 0, 8 },
    { "lightning", "Lightning", 5000, 55 },
    { "magic rope", "Magic Rope", 200, 9 },
    { "magic shield", "Magic Shield", 450, 14 },
    { "rage of the skies", "Rage of the Skies", 6000, 55 },
    { "restoration", "Restoration", 500000, 300 },
    { "sap strength", "Sap Strength", 200000, 175 },
    { "scorch", "Scorch", 0, 1 },
    { "summon creature", "Summon Creature", 2000, 25 },
    { "summon sorcerer familiar", "Summon Sorcerer Familiar", 50000, 200 },
    { "animate dead rune", "Animate Dead Rune", 1200, 27 },
    { "destroy field rune", "Destroy Field Rune", 700, 17 },
    { "disintegrate rune", "Disintegrate Rune", 900, 21 },
    { "energy bomb rune", "Energy Bomb Rune", 2300, 37 },
    { "energy field rune", "Energy Field Rune", 700, 18 },
    { "energy wall rune", "Energy Wall Rune", 2500, 41 },
    { "explosion rune", "Explosion Rune", 1800, 31 },
    { "fire bomb rune", "Fire Bomb Rune", 1500, 27 },
    { "fire field rune", "Fire Field Rune", 500, 15 },
    { "fire wall rune", "Fire Wall Rune", 2000, 33 },
    { "great fireball rune", "Great Fireball Rune", 1200, 30 },
    { "fireball rune", "Fireball Rune", 1600, 27 },
    { "heavy magic missile rune", "Heavy Magic Missile Rune", 1500, 25 },
    { "light magic missile rune", "Light Magic Missile Rune", 1700, 15 },
    { "magic wall rune", "Magic Wall Rune", 2100, 32 },
    { "poison field rune", "Poison Field Rune", 300, 14 },
    { "poison wall rune", "Poison Wall Rune", 1600, 29 },
    { "soulfire rune", "Soulfire Rune", 1800, 27 },
    { "stalagmite rune", "Stalagmite Rune", 1400, 24 },
    { "sudden death rune", "Sudden Death Rune", 3000, 45 },
    { "thunderstorm rune", "Thunderstorm Rune", 1100, 28 },
    { "strong energy strike", "Strong Energy Strike", 7500, 80 },
    { "strong flame strike", "Strong Flame Strike", 6000, 70 },
    { "haste", "Haste", 600, 14 },
    { "light", "Light", 0, 8 },
    { "ice strike", "Ice Strike", 800, 15 },
    { "terra strike", "Terra Strike", 800, 13 },
    { "death strike", "Death Strike", 800, 16 },
    { "energy strike", "Energy Strike", 800, 12 },
    { "flame strike", "Flame Strike", 800, 14 },
}


for _, spellInfo in ipairs(spells) do
    addSpellKeyword({ spellInfo[1] }, spellInfo[2], spellInfo[3], spellInfo[4])
end

-- Sorcerer's Spells List 
keywordHandler:addKeyword({ "attack" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Apprentice's Strike}, {Ignite}, {Flame Strike}, {Strong Flame Strike}, {Ultimate Flame Strike}, {Scorch}, {Fire Wave}, {Great Fire Wave}, {Hell's Core}, {Buzz}, {Electrify}, {Energy Strike}, {Strong Energy Strike}, {Ultimate Energy Strike}, {Energy Wave}, {Energy Beam}, {Great Energy Beam}, {Lightning}, {Rage of the Skies}, {Curse}, {Death Strike}, {Ice Strike} and {Terra Strike}.",
})
keywordHandler:addKeyword({ "healing" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Cure Poison}, {Light Healing}, {Intense Healing}, {Ultimate Healing}, and {Restoration}.",
})
keywordHandler:addKeyword({ "support" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Creature Illusion}, {Expose Weakness}, {Find Fiend}, {Find Person}, {Invisible}, {Levitate}, {Light}, {Great Light}, {Ultimate Light}, {Magic Shield}, {Cancel Magic Shield}, {Sap Strength}, {Haste}, {Strong Haste}, and {Magic Rope}.",
})
keywordHandler:addKeyword({ "conjure" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Conjure Wand of Darkness}.",
})
keywordHandler:addKeyword({ "summon" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Summon Creature} and {Summon Sorcerer Familiar}.",
})
keywordHandler:addKeyword({ "runes" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Animate Dead Rune}, {Destroy Field Rune}, {Disintegrate Rune}, {Energy Bomb Rune}, {Energy Field Rune}, {Energy Wall Rune}, {Explosion Rune}, {Fire Bomb Rune}, {Fire Field Rune}, {Fire Wall Rune}, {Fireball Rune}, {Great Fireball Rune}, {Soulfire Rune}, {Light Magic Missile Rune}, {Heavy Magic Missile Rune}, {Magic Wall Rune}, {Poison Field Rune}, {Stalagmite Rune}, {Poison Wall Rune}, {Sudden Death Rune} and {Thunderstorm Rune}.",
})
keywordHandler:addKeyword({ "party" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Enchant Party}.",
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