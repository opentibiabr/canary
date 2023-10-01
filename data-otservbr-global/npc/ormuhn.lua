local internalNpcName = "Ormuhn"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 18
}

npcConfig.flags = {
	floorchange = false
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

keywordHandler:addSpellKeyword({'find', 'person'},
	{
		npcHandler = npcHandler,
		spellName = 'Find Person',
		price = 80,
		level = 8,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'great', 'light'},
	{
		npcHandler = npcHandler,
		spellName = 'Great Light',
		price = 500,
		level = 13,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'light'},
	{
		npcHandler = npcHandler,
		spellName = 'Light',
		price = 0,
		level = 8,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'magic', 'rope'},
	{
		npcHandler = npcHandler,
		spellName = 'Magic Rope',
		price = 200,
		level = 9,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'cure', 'poison'},
	{
		npcHandler = npcHandler,
		spellName = 'Cure Poison',
		price = 150,
		level = 10,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'intense', 'wound', 'cleansing'},
	{
		npcHandler = npcHandler,
		spellName = 'Intense Wound Cleansing',
		price = 6000,
		level = 80,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'wound', 'cleansing'},
	{
		npcHandler = npcHandler,
		spellName = 'Wound Cleansing',
		price = 0,
		level = 8,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'levitate'},
	{
		npcHandler = npcHandler,
		spellName = 'Levitate',
		price = 500,
		level = 12,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'haste'},
	{
		npcHandler = npcHandler,
		spellName = 'Haste',
		price = 600,
		level = 14,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'brutal', 'strike'},
	{
		npcHandler = npcHandler,
		spellName = 'Brutal Strike',
		price = 1000,
		level = 16,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'charge'},
	{
		npcHandler = npcHandler,
		spellName = 'Charge',
		price = 1300,
		level = 25,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'whirlwind', 'throw'},
	{
		npcHandler = npcHandler,
		spellName = 'Whirlwind Throw',
		price = 1500,
		level = 28,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'groundshaker'},
	{
		npcHandler = npcHandler,
		spellName = 'Groundshaker',
		price = 1500,
		level = 33,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'fierce', 'berserk'},
	{
		npcHandler = npcHandler,
		spellName = 'Fierce Berserk',
		price = 7500,
		level = 90,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'berserk'},
	{
		npcHandler = npcHandler,
		spellName = 'Berserk',
		price = 2500,
		level = 35,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'inflict', 'wound'},
	{
		npcHandler = npcHandler,
		spellName = 'Inflict Wound',
		price = 2500,
		level = 40,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'cure', 'bleeding'},
	{
		npcHandler = npcHandler,
		spellName = 'Cure Bleeding',
		price = 2500,
		level = 45,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'intense', 'recovery'},
	{
		npcHandler = npcHandler,
		spellName = 'Intense Recovery',
		price = 10000,
		level = 100,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'recovery'},
	{
		npcHandler = npcHandler,
		spellName = 'Recovery',
		price = 4000,
		level = 50,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'front', 'sweep'},
	{
		npcHandler = npcHandler,
		spellName = 'Front Sweep',
		price = 4000,
		level = 70,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({'annihilation'},
	{
		npcHandler = npcHandler,
		spellName = 'Annihilation',
		price = 20000,
		level = 110,
		vocation = VOCATION.BASE_ID.KNIGHT
	}
)

keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "In this category I have '{Bruise Bane}', '{Cure Bleeding}', '{Wound Cleansing}', '{Cure Poison}', '{Intense Wound Cleansing}', '{Recovery}' and '{Intense Recovery}'."
	}
)
keywordHandler:addKeyword({'attack', 'spells'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = {"In this category I have '{Whirlwind Throw}', '{Groundshaker}', '{Berserk}' and '{Fierce Berserk}' as well as ...", "'{Brutal Strike}', '{Front Sweep}', '{Inflict Wound}' and '{Annihilation}'"}
	}
)
keywordHandler:addKeyword({'support', 'spells'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "In this category I have '{Light}', '{Find Person}', '{Magic Rope}', '{Levitate}', '{Haste}', '{Charge}' and '{Great Light}'."
	}
)
keywordHandler:addKeyword({'spells'}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I can teach you {healing spells}, {attack spells} and {support spells}. What kind of spell do you wish to learn? You can also tell me for which level you would like to learn a spell, if you prefer that.'
	}
)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
