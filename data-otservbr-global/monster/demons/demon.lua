local mType = Game.createMonsterType("Demon")
local monster = {}

monster.description = "a demon"
monster.experience = 6000
monster.outfit = {
	lookType = 35,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 35
monster.Bestiary = {
	class = "Demon",
	race = BESTY_RACE_DEMON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Hero Cave, Ferumbras' Citadel, Goroma, Ghostlands Warlock area unreachable, Liberty Bay hidden underground passage unreachable, Razachai, deep in Pits of Inferno (found in every throneroom except Verminor's), deep Formorgar Mines, Demon Forge, Alchemist Quarter, Magician Quarter, Chyllfroest, Oramond Dungeon, Abandoned Sewers, Hell Hub and Halls of Ascension.",
}

monster.health = 8200
monster.maxHealth = 8200
monster.race = "fire"
monster.corpse = 5995
monster.speed = 128
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 20,
}

monster.strategiesTarget = {
	nearest = 70,
	health = 10,
	damage = 10,
	random = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
	hasGroupedSpells = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 1,
	summons = {
		{ name = "fire elemental", chance = 10, interval = 2000, count = 1 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Your soul will be mine!", yell = false },
	{ text = "CHAMEK ATH UTHUL ARAK!", yell = true },
	{ text = "I SMELL FEEEEAAAAAR!", yell = true },
	{ text = "Your resistance is futile!", yell = false },
	{ text = "MUHAHAHAHA!", yell = true },
}

monster.loot = {
	{ name = "gold coin", chance = 60000, maxCount = 100 },
	{ name = "gold coin", chance = 60000, maxCount = 100 },
	{ name = "platinum coin", chance = 99580, maxCount = 8 },
	{ name = "great mana potion", chance = 25150, maxCount = 3 },
	{ name = "great spirit potion", chance = 24650, maxCount = 3 },
	{ name = "ultimate health potion", chance = 20010, maxCount = 3 },
	{ name = "demon horn", chance = 20000 },
	{ name = "fire mushroom", chance = 19840, maxCount = 6 },
	{ name = "demonic essence", chance = 19650 },
	{ name = "assassin star", chance = 15340, maxCount = 10 },
	{ name = "small topaz", chance = 10110, maxCount = 5 },
	{ name = "small ruby", chance = 10040, maxCount = 5 },
	{ name = "small emerald", chance = 9930, maxCount = 5 },
	{ name = "small amethyst", chance = 9790, maxCount = 5 },
	{ name = "fire axe", chance = 4070 },
	{ name = "talon", chance = 3440 },
	{ id = 3039, chance = 2950 }, -- red gem
	{ name = "orb", chance = 2850 },
	{ id = 3098, chance = 2610 }, -- ring of healing
	{ name = "might ring", chance = 2450 },
	{ id = 3049, chance = 2370 }, -- stealth ring
	{ name = "giant sword", chance = 1960 },
	{ name = "ice rapier", chance = 1940 },
	{ name = "golden sickle", chance = 1360 },
	{ name = "purple tome", chance = 1270 },
	{ name = "devil helmet", chance = 1240 },
	{ name = "gold ring", chance = 1040 },
	{ name = "demon shield", chance = 730 },
	{ name = "platinum amulet", chance = 700 },
	{ name = "mastermind shield", chance = 500 },
	{ name = "golden legs", chance = 380 },
	{ id = 7393, chance = 90 }, -- demon trophy
	{ name = "magic plate armor", chance = 80 },
	{ name = "demonrage sword", chance = 60 },
}

monster.attacks = {
	{ name = "melee", group = MONSTER_SPELL_GROUP_BASIC, chance = 100, minDamage = 0, maxDamage = -520 },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 75, type = COMBAT_FIREDAMAGE, minDamage = -150, maxDamage = -250, range = 7, radius = 7, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = true },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 25, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -480, length = 8, spread = 0, effect = CONST_ME_PURPLEENERGY, target = false },
	{ name = "combat", group = MONSTER_SPELL_GROUP_ATTACK, chance = 25, type = COMBAT_ENERGYDAMAGE, minDamage = -210, maxDamage = -300, range = 1, shootEffect = CONST_ANI_ENERGY, target = true },
	{ name = "firefield", group = MONSTER_SPELL_GROUP_ATTACK, chance = 25, range = 7, radius = 1, shootEffect = CONST_ANI_FIRE, target = true },
	{ name = "combat", group = MONSTER_SPELL_GROUP_DRAIN, chance = 20, type = COMBAT_MANADRAIN, minDamage = -30, maxDamage = -120, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ANI_SMALLEARTH, target = true },
	{ name = "speed", group = MONSTER_SPELL_GROUP_STATUS, chance = 15, speedChange = -700, radius = 1, effect = CONST_ME_MAGIC_RED, target = true, duration = 30000 },
}

monster.defenses = {
	defense = 55,
	armor = 44,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 180, maxDamage = 250, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 50 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 100 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = -12 },
	{ type = COMBAT_HOLYDAMAGE, percent = -12 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
