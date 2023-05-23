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
	lookAddons = 2
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

-- spells for druid and sorcerer
keywordHandler:addSpellKeyword({"findperson"},
	{
		npcHandler = npcHandler,
		spellName = "Find Person",
		price = 0,
		level = 8,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"apprenticesstrike"},
	{
		npcHandler = npcHandler,
		spellName = "Apprentice's Strike",
		price = 0,
		level = 8,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"lighthealing"},
	{
		npcHandler = npcHandler,
		spellName = "Light Healing",
		price = 0,
		level = 8,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"light"},
	{
		npcHandler = npcHandler,
		spellName = "Light",
		price = 0,
		level = 8,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"magicrope"},
	{
		npcHandler = npcHandler,
		spellName = "Magic Rope",
		price = 0,
		level = 9,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"curepoison"},
	{
		npcHandler = npcHandler,
		spellName = "Cure Poison",
		price = 0,
		level = 10,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"energystrike"},
	{
		npcHandler = npcHandler,
		spellName = "Energy Strike",
		price = 0,
		level = 12,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"levitate"},
	{
		npcHandler = npcHandler,
		spellName = "Levitate",
		price = 0,
		level = 12,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"greatlight"},
	{
		npcHandler = npcHandler,
		spellName = "Great Light",
		price = 0,
		level = 13,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"terrastrike"},
	{
		npcHandler = npcHandler,
		spellName = "Terra Strike",
		price = 0,
		level = 13,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"haste"},
	{
		npcHandler = npcHandler,
		spellName = "Haste",
		price = 0,
		level = 14,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"flamestrike"},
	{
		npcHandler = npcHandler,
		spellName = "Flame Strike",
		price = 0,
		level = 14,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"icestrike"},
	{
		npcHandler = npcHandler,
		spellName = "Ice Strike",
		price = 0,
		level = 15,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"poisonfield"},
	{
		npcHandler = npcHandler,
		spellName = "Poison Field",
		price = 0,
		level = 14,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"firefield"},
	{
		npcHandler = npcHandler,
		spellName = "Fire Field",
		price = 0,
		level = 15,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"lightmagicmissile"},
	{
		npcHandler = npcHandler,
		spellName = "Light Magic Missile",
		price = 0,
		level = 15,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
keywordHandler:addSpellKeyword({"energyfield"},
	{
		npcHandler = npcHandler,
		spellName = "Energy Field",
		price = 0,
		level = 18,
		vocation = {
			VOCATION.BASE_ID.SORCERER,
			VOCATION.BASE_ID.DRUID
		}
	}
)
-- spells for sorcerer
keywordHandler:addSpellKeyword({"deathstrike"},
	{
		npcHandler = npcHandler,
		spellName = "Death Strike",
		price = 0,
		level = 16,
		vocation = VOCATION.BASE_ID.SORCERER
	}
)
keywordHandler:addSpellKeyword({"firewave"},
	{
		npcHandler = npcHandler,
		spellName = "Fire Wave",
		price = 0,
		level = 18,
		vocation = VOCATION.BASE_ID.SORCERER
	}
)
-- spells for druid
keywordHandler:addSpellKeyword({"icewave"},
	{
		npcHandler = npcHandler,
		spellName = "Ice Wave",
		price = 0,
		level = 18,
		vocation = VOCATION.BASE_ID.DRUID
	}
)
keywordHandler:addSpellKeyword({"physicalstrike"},
	{
		npcHandler = npcHandler,
		spellName = "Physical Strike",
		price = 0,
		level = 16,
		vocation = VOCATION.BASE_ID.DRUID
	}
)
keywordHandler:addSpellKeyword({"healfriend"},
	{
		npcHandler = npcHandler,
		spellName = "Heal Friend",
		price = 0,
		level = 18,
		vocation = VOCATION.BASE_ID.DRUID
	}
)

keywordHandler:addKeyword({"healing spells"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "In this category I have '{Lighthealing}', '{Healfriend}', and '{Curepoison}'."
	}
)
keywordHandler:addKeyword({"support spells"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "In this category I have '{Findperson}', '{Magicrope}', '{Levitate}', '{Light}', \z
		'{Greatlight}', '{Haste}', '{Poisonfield}', '{Firefield}', '{Lightmagicmissile}' and '{Energyfield}'."
	}
)
keywordHandler:addKeyword({"attack spells"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "In this category I have '{Deathstrike}', '{Firewave}', '{Apprenticesstrike}', '{Energystrike}', \z
		'{Terrastrike}', '{Flamestrike}', '{Icestrike}', '{Physicalstrike}', '{Icewave}'."
	}
)
keywordHandler:addKeyword({"spells"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I can teach you {healing spells}, {support spells} and {attack spells}. \z
		What kind of spell do you wish to learn?"
	}
)

keywordHandler:addKeyword({"name"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I am Garamond Starstream."
	}
)
keywordHandler:addKeyword({"job"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Did you not listen? I am the teacher of druid and sorcerer spells for level 8 to 18. \z
		I teach young adventurers spells they can use once they have the proper vocation - druid or sorcerer."
	}
)
keywordHandler:addKeyword({"rookgaard"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "I have an old friend there. Haven't heard from him in a while."
	}
)
keywordHandler:addKeyword({"dawnport"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Oh, it's not too bad here, believe me. At least I always get young and enthusiast disciples! \z
		Though I must confess I miss the vastness of the Tibian plains. <sighs>"
	}
)
keywordHandler:addKeyword({"inigo"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A kind old hunter. He loves to see young life around, taking on the ways and lays of the land. \z
		If you have any question, ask Inigo for help."
	}
)
keywordHandler:addKeyword({"coltrayne"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Roughened and toughened by life's tragedies. A good man, but somber."
	}
)
keywordHandler:addKeyword({"garamond"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Yes, child. If you wish to learn a spell, tell me."
	}
)
keywordHandler:addKeyword({"hamish"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A very headstrong young man, though I appreciate his devotion to the craft of potion-making. \z
		No respect for senior authority or age at all! Except maybe for a little soft spot for Mr Morris."
	}
)
keywordHandler:addKeyword({"mr morris"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "A strange young man. He seems driven, to my mind. By what force, I do not know. \z
		I take it the world needs adventurers such as him."
	}
)
keywordHandler:addKeyword({"plunderpurse"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Redeeming one's soul by becoming a clerk? Not very likely. Once a pirate, always a pirate. \z
		But he's a charming old rogue."
	}
)
keywordHandler:addKeyword({"richard"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Not a half bad cook, truly. Must have been that squirrel diet, it seems to have lead him to \z
		discover a new cuisine - everything to forget the bad taste of squirrels, he said."
	}
)
keywordHandler:addKeyword({"ser tybald"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "He is proficient in the martial arts. A very skilled teacher of spells for knights and paladins. \z
		If that is your vocation, you should talk to Ser Tybald."
	}
)
keywordHandler:addKeyword({"wentworth"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Ah, yes. Travelled with Plunderpurse a lot as I recall. Captain Plunderpurse, then. \z
			Got his head full of numbers and statistics, that boy."
	}
)

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "magic") then
		npcHandler:say(
			{
			"Spells are very useful in combat - not only for mages, though of course we particularly \z
			rely on them for much of our damage output. ...",
			"There's a broad variety of what spells can do, as you will see as you progress further. \z
			The next spells you can buy with level 8 and on. ...",
			"Some attack spells can be directed at a single target while others affect an area, having \z
			an effect either over time or instantaneous. Even other spells protect you, or can be used to create runes. ...",
			"Each vocation has its own individual spells that none of the other vocations can use. \z
			You can only learn spells at a spell trainer of your vocation. ...",
			"The spells here on Dawnport are for trying out only, and you will forget them once \z
			you choose your definite vocation and leave for the Mainland. ...",
			"There, you can go to a spell teacher in a city to permanently learn a spell."
			},
		creature)
	elseif MsgContains(message, "mainland") then
		npcHandler:say(
			{
			"The Mainland offers many more adventures, dangers and quests than this small isle, \z
			and also has spell teachers where you can permanently learn a spell for your vocation. ...",
			"Once you reach level 8 you may choose your definite vocation and leave for Main. Go to a city \z
			and seek out the spell trainer of your vocation to learn a spell. And make sure you have enough gold! ...",
			"The art of spell teaching is complex and dangerous, and we will only impart our valuable \z
			knowledge of a spell to a novice if they can pay the price."
			},
		creature)
	elseif MsgContains(message, "tibian") then
		npcHandler:say(
			{
			"Ah, the beauty of our world! It is vast and extraordinarily diverse. Strange islands, beautiful cities \z
			and fierce monsters that roam the wildernesses. Mysteries, adventures, danger around every corner. ...",
			"Once you have reached level 8, you are ready to choose a vocation and go to the Tibian Mainland."
			},
		creature)
	elseif MsgContains(message, "vocation") then
		npcHandler:say(
			{
			"Your choice of vocation will determine your life in Tibia, and the skills and fighting techniques you may use. ...",
			"There are four vocation: knight, druid, paladin and sorcerer. If you want to know more about them, \z
			talk to Oressa in the temple. ...",
			"I myself teach try-out spells for both the magical classes, \z
			whereas Tybald in the next room specialises in knight and paladin spells."
			},
		creature)
	elseif MsgContains(message, "oressa") then
		npcHandler:say(
			{
			"A very intelligent girl. Prefers to listen to wild animals' noises instead of humans', \z
			which is quite understandable when you think about it. ...",
			"However, she's also a very apt healer and can give you advice on your choice of vocation."
			},
		creature)
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome, child. Have you come to learn about {magic}? \z
	Then you are in the right place. I can teach you many useful {spells}.")
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
