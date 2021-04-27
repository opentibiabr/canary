local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

keywordHandler:addSpellKeyword({"find", "person"},
	{
		npcHandler = npcHandler,
		spellName = "Find Person",
		price = 80,
		level = 8,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"great", "light"},
	{
		npcHandle = npcHandler,
		spellName = "Great Light",
		price = 500,
		level = 13,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"light"},
	{
		npcHandle = npcHandler,
		spellName = "Light",
		price = 0,
		level = 8,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"magic", "rope"},
	{
		npcHandle = npcHandler,
		spellName = "Magic Rope",
		price = 200,
		level = 9,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"cure", "poison"},
	{
		npcHandle = npcHandler,
		spellName = "Cure Poison",
		price = 150,
		level = 10,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"intense", "wound", "cleansing"},
	{
		npcHandle = npcHandler,
		spellName = "Intense Wound Cleansing",
		price = 6000,
		level = 80,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"wound", "cleansing"},
	{
		npcHandle = npcHandler,
		spellName = "Wound Cleansing",
		price = 0,
		level = 8,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"levitate"},
	{
		npcHandle = npcHandler,
		spellName = "Levitate",
		price = 500,
		level = 12,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"haste"},
	{
		npcHandle = npcHandler,
		spellName = "Haste",
		price = 600,
		level = 14,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"brutal", "strike"},
	{
		npcHandle = npcHandler,
		spellName = "Brutal Strike",
		price = 1000,
		level = 16,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"charge"},
	{
		npcHandle = npcHandler,
		spellName = "Charge",
		price = 1300,
		level = 25,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"whirlwind", "throw"},
	{
		npcHandle = npcHandler,
		spellName = "Whirlwind Throw",
		price = 1500,
		level = 28,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"groundshaker"},
	{
		npcHandle = npcHandler,
		spellName = "Groundshaker",
		price = 1500,
		level = 33,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"fierce", "berserk"},
	{
		npcHandle = npcHandler,
		spellName = "Fierce Berserk",
		price = 7500,
		level = 90,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"berserk"},
	{
		npcHandle = npcHandler,
		spellName = "Berserk",
		price = 2500,
		level = 35,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"inflict", "wound"},
	{
		npcHandle = npcHandler,
		spellName = "Inflict Wound",
		price = 2500,
		level = 40,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"cure", "bleeding"},
	{
		npcHandle = npcHandler,
		spellName = "Cure Bleeding",
		price = 2500,
		level = 45,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"intense", "recovery"},
	{
		npcHandle = npcHandler,
		spellName = "Intense Recovery",
		price = 10000,
		level = 100,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"recovery"},
	{
		npcHandle = npcHandler,
		spellName = "Recovery",
		price = 4000,
		level = 50,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"front", "sweep"},
	{
		npcHandle = npcHandler,
		spellName = "Front Sweep",
		price = 4000,
		level = 70,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)
keywordHandler:addSpellKeyword({"annihilation"},
	{
		npcHandle = npcHandler,
		spellName = "Annihilation",
		price = 20000,
		level = 110,
		vocation = VOCATION.CLIENT_ID.KNIGHT
	}
)

keywordHandler:addKeyword({"healing", "spells"}, StdModule.say,
	{
		npcHandle = npcHandler,
		text = "In this category I have '{Bruise Bane}', '{Cure Bleeding}', '{Wound Cleansing}', \z
		'{Cure Poison}'', '{Intense Wound Cleansing}'', '{Recovery}'' and '{Intense Recovery}''."
	}
)
keywordHandler:addKeyword({"attack", "spells"}, StdModule.say,
	{
		npcHandle = npcHandler,
		text = {"In this category I have '{Whirlwind Throw}', '{Groundshaker}', '{Berserk}' and \z
		'{Fierce Berserk}' as well as ...', ''{Brutal Strike}', '{Front Sweep}', '{Inflict Wound}' and '{Annihilation}'"}
	}
)
keywordHandler:addKeyword({"support", "spells"}, StdModule.say,
	{
		npcHandle = npcHandler,
		text = "In this category I have '{Light}', '{Find Person}', '{Magic Rope}', '{Levitate}', \z
		'{Haste}', '{Charge}' and '{Great Light}'."
	}
)
keywordHandler:addKeyword({"spells"}, StdModule.say,
	{
		npcHandle = npcHandler,
		text = "I can teach you {healing spells}, {attack spells} and {support spells}. \z
		What kind of spell do you wish to learn? \z
		You can also tell me for which level you would like to learn a spell, if you prefer that."
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Yeah, another fool {disturbing} me, what a joy.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Whatever.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Whatever.")

npcHandler:addModule(FocusModule:new())
