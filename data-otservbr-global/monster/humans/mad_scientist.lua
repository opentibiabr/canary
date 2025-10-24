local mType = Game.createMonsterType("Mad Scientist")
local monster = {}

monster.description = "a mad scientist"
monster.experience = 205
monster.outfit = {
	lookType = 133,
	lookHead = 39,
	lookBody = 0,
	lookLegs = 19,
	lookFeet = 20,
	lookAddons = 1,
	lookMount = 0,
}

monster.raceId = 528
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Magician Quarter, Trade Quarter, Factory Quarter,Isle of Evil, Tiquanda Laboratory.",
}

monster.health = 325
monster.maxHealth = 325
monster.race = "blood"
monster.corpse = 18158
monster.speed = 90
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Die in the name of Science!", yell = false },
	{ text = "You will regret interrupting my studies!", yell = false },
	{ text = "Let me test this!", yell = false },
	{ text = "I will study your corpse!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 60110, maxCount = 115 }, -- Gold Coin
	{ id = 266, chance = 17569 }, -- Health Potion
	{ id = 268, chance = 18336 }, -- Mana Potion
	{ id = 3739, chance = 6516 }, -- Powder Herb
	{ id = 3723, chance = 14930, maxCount = 3 }, -- White Mushroom
	{ id = 3061, chance = 1943 }, -- Life Crystal
	{ id = 3046, chance = 2060 }, -- Magic Light Wand
	{ id = 3598, chance = 2418, maxCount = 5 }, -- Cookie
	{ id = 6393, chance = 752 }, -- Cream Cake
	{ id = 678, chance = 593 }, -- Small Enchanted Amethyst
	{ id = 7440, chance = 146 }, -- Mastermind Potion
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -35 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DROWNDAMAGE, minDamage = -20, maxDamage = -56, range = 7, radius = 3, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_POFF, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -20, maxDamage = -36, shootEffect = CONST_ANI_POISON, effect = CONST_ME_ENERGYHIT, target = false },
	{ name = "speed", interval = 2000, chance = 10, speedChange = -300, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_SMALLPLANTS, target = true, duration = 2000 },
}

monster.defenses = {
	defense = 15,
	armor = 15,
	mitigation = 0.64,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 10, maxDamage = 30, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = 20 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
