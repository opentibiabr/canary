local mType = Game.createMonsterType("Draken Abomination")
local monster = {}

monster.description = "a draken abomination"
monster.experience = 3800
monster.outfit = {
	lookType = 357,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 673
monster.Bestiary = {
	class = "Dragon",
	race = BESTY_RACE_DRAGON,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Razachai including the Inner Sanctum.",
}

monster.health = 6250
monster.maxHealth = 6250
monster.race = "venom"
monster.corpse = 11667
monster.speed = 135
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
	canPushCreatures = false,
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Death Blob", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Uhhhg!", yell = false },
	{ text = "Gll", yell = false },
	{ text = "Hmmnn!", yell = false },
	{ text = "Aaag!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 97439, maxCount = 199 }, -- Gold Coin
	{ id = 3577, chance = 49714, maxCount = 4 }, -- Meat
	{ id = 3035, chance = 49799, maxCount = 8 }, -- Platinum Coin
	{ id = 11671, chance = 12189 }, -- Eye of Corruption
	{ id = 11673, chance = 10340 }, -- Scale of Corruption
	{ id = 7643, chance = 9333, maxCount = 3 }, -- Ultimate Health Potion
	{ id = 238, chance = 9544, maxCount = 3 }, -- Great Mana Potion
	{ id = 830, chance = 8550 }, -- Terra Hood
	{ id = 11672, chance = 6004 }, -- Tail of Corruption
	{ id = 7642, chance = 4888, maxCount = 3 }, -- Great Spirit Potion
	{ id = 9057, chance = 2923, maxCount = 4 }, -- Small Topaz
	{ id = 8094, chance = 1095 }, -- Wand of Voodoo
	{ id = 10387, chance = 975 }, -- Zaoan Legs
	{ id = 10384, chance = 838 }, -- Zaoan Armor
	{ id = 10385, chance = 524 }, -- Zaoan Helmet
	{ id = 4033, chance = 433 }, -- Draken Boots
	{ id = 12549, chance = 159 }, -- Bamboo Leaves
	{ id = 11688, chance = 15 }, -- Shield of Corruption
	{ id = 11691, chance = 15 }, -- Snake God's Wristguard
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -420 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_FIREDAMAGE, minDamage = -310, maxDamage = -630, length = 4, spread = 3, effect = CONST_ME_EXPLOSIONHIT, target = false },
	{ name = "draken abomination curse", interval = 2000, chance = 10, range = 5, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_DEATHDAMAGE, minDamage = -170, maxDamage = -370, length = 4, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "drunk", interval = 2000, chance = 15, range = 7, radius = 4, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = false, duration = 9000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, range = 7, radius = 3, effect = CONST_ME_HITBYPOISON, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 45,
	mitigation = 1.60,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 650, maxDamage = 700, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
