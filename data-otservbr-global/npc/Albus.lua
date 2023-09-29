local internalNpcName = "Albus"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 634,
	lookHead = 0,
	lookBody = 111,
	lookLegs = 93,
	lookFeet = 94,
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


local function addSpellKeyword(spellKeyword, spellName, price, level)
    keywordHandler:addSpellKeyword(spellKeyword, {
        npcHandler = npcHandler,
        spellName = spellName,
        price = price,
        level = level,
        vocation = VOCATION.BASE_ID.DRUID
    })
end

-- Druid's Spells Configurations 
local spells = {
    { "cure poison rune", "Cure Poison Rune", 600, 15 },
    { "cure burning", "Cure Burning", 2000, 30 },
    { "cure electrification", "Cure Electrification", 1000, 22 },
    { "cure poison", "Cure Poison", 150, 10 },
    { "energy strike", "Energy Strike", 800, 12 },
    { "physical strike", "Physical Strike", 800, 16 },
    { "envenom", "Envenom", 6000, 50 },
    { "eternal winter", "Eternal Winter", 8000, 60 },
    { "find fiend", "Find Fiend", 1000, 25 },
    { "find person", "Find Person", 80, 8 },
    { "flame strike", "Flame Strike", 800, 14 },
    { "food", "Food", 300, 14 },
    { "ultimate light", "Ultimate Light", 1600, 26 },
    { "great light", "Great Light", 500, 13 },
    { "strong haste", "Strong Haste", 1300, 20 },
    { "haste", "Haste", 600, 14 },
    { "heal friend", "Heal Friend", 800, 18 },
    { "heal party", "Heal Party", 4000, 32 },
    { "intense healing", "Intense Healing", 350, 20 },
    { "invisible", "Invisible", 2000, 35 },
    { "levitate", "Levitate", 500, 12 },
    { "light healing", "Light Healing", 0, 8 },
    { "magic patch", "Magic Patch", 0, 1 },
    { "magic rope", "Magic Rope", 200, 9 },
    { "magic shield", "Magic Shield", 450, 14 },
    { "mass healing", "Mass Healing", 2200, 36 },
    { "mud attack", "Mud Attack", 0, 1 },
    { "nature's embrace", "Nature's Embrace", 500000, 300 },
    { "restoration", "Restoration", 500000, 300 },
    { "ultimate ice strike", "Ultimate Ice Strike", 15000, 100 },
    { "strong ice strike", "Strong Ice Strike", 6000, 80 },
    { "ice strike", "Ice Strike", 800, 15 },
    { "strong ice wave", "Strong Ice Wave", 7500, 40 },
    { "ice wave", "Ice Wave", 850, 18 },
    { "summon creature", "Summon Creature", 2000, 25 },
    { "summon druid familiar", "Summon Druid Familiar", 50000, 200 },
    { "ultimate terra strike", "Ultimate Terra Strike", 15000, 90 },
    { "strong terra strike", "Strong Terra Strike", 6000, 70 },
    { "terra strike", "Terra Strike", 800, 13 },
    { "terra wave", "Terra Wave", 2500, 38 },
    { "ultimate healing", "Ultimate Healing", 1000, 30 },
    { "wrath of nature", "Wrath of Nature", 6000, 55 },
    { "animate dead rune", "Animate Dead Rune", 1200, 27 },
    { "avalanche rune", "Avalanche Rune", 1200, 30 },
    { "chameleon rune", "Chameleon Rune", 1300, 27 },
    { "convince creature rune", "Convince Creature Rune", 800, 16 },
    { "destroy field rune", "Destroy Field Rune", 700, 17 },
    { "disintegrate rune", "Disintegrate Rune", 900, 21 },
    { "energy field rune", "Energy Field Rune", 700, 18 },
    { "energy wall rune", "Energy Wall Rune", 2500, 41 },
    { "explosion rune", "Explosion Rune", 1800, 31 },
    { "fire bomb rune", "Fire Bomb Rune", 1500, 27 },
    { "fire field rune", "Fire Field Rune", 500, 15 },
    { "fire wall rune", "Fire Wall Rune", 2000, 33 },
    { "heavy magic missile rune", "Heavy Magic Missile Rune", 1500, 25 },
    { "icicle rune", "Icicle Rune", 1700, 28 },
    { "intense healing rune", "Intense Healing Rune", 600, 15 },
    { "light magic missile rune", "Light Magic Missile Rune", 500, 15 },
    { "paralyse rune", "Paralyse Rune", 1900, 54 },
    { "poison bomb rune", "Poison Bomb Rune", 1000, 25 },
    { "poison field rune", "Poison Field Rune", 300, 14 },
    { "poison wall rune", "Poison Wall Rune", 1600, 29 },
    { "soulfire rune", "Soulfire Rune", 1800, 27 },
    { "stalagmite rune", "Stalagmite Rune", 1400, 24 },
    { "stone shower rune", "Stone Shower Rune", 1100, 28 },
    { "ultimate healing rune", "Ultimate Healing Rune", 1500, 24 },
    { "wild growth rune", "Wild Growth Rune", 2000, 27 },
    { "light", "Light", 0, 8 },
}

for _, spellInfo in ipairs(spells) do
    addSpellKeyword({ spellInfo[1] }, spellInfo[2], spellInfo[3], spellInfo[4])
end

-- Druid's Spells List
keywordHandler:addKeyword({ "attack" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Envenom}, {Mud Attack}, {Physical Strike}, {Energy Strike}, {Flame Strike}, {Ice Strike}, {Strong Ice Strike}, {Ultimate Ice Strike}, {Ice Wave}, {Strong Ice Wave}, {Eternal Winter}, {Terra Strike}, {Strong Terra Strike}, {Ultimate Terra Strike}, {Terra Wave} and {Wrath of Nature}.",
})
keywordHandler:addKeyword({ "healing" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Cure Burning}, {Cure Electrification}, {Cure Poison}, {Magic Patch}, {Light Healing}, {Intense Healing}, {Mass Healing}, {Ultimate Healing}, {Heal Friend}, {Nature's Embrace}, and {Restoration}.",
})
keywordHandler:addKeyword({ "support" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Find Fiend}, {Find Person}, {Light}, {Great Light}, {Ultimate Light}, {Invisible}, {Levitate}, {Magic Rope}, {Magic Shield}, {Haste} and {Strong Haste}.",
})
keywordHandler:addKeyword({ "conjure" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Food}.",
})
keywordHandler:addKeyword({ "summon" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Summon Creature} and {Summon Druid Familiar}.",
})
keywordHandler:addKeyword({ "runes" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Animate Dead Rune}, {Convince Creature Rune}, {Icicle Rune}, {Avalanche Rune}, {Chameleon Rune}, {Cure Poison Rune}, {Destroy Field Rune}, {Disintegrate Rune}, {Energy Field Rune}, {Energy Wall Rune}, {Explosion Rune}, {Fire Bomb Rune}, {Fire Field Rune}, {Fire Wall Rune}, {Soulfire Rune}, {Light Magic Missile Rune}, {Heavy Magic Missile Rune}, {Intense Healing Rune}, {Ultimate Healing Rune}, {Paralyse Rune}, {Poison Bomb Rune}, {Poison Field Rune}, {Poison Wall Rune}, {Stalagmite Rune}, {Wild Growth Rune} and {Stone Shower Rune}.",
})
keywordHandler:addKeyword({ "party" }, StdModule.say, {
    npcHandler = npcHandler,
    text = "In this category I have {Heal Party}.",
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