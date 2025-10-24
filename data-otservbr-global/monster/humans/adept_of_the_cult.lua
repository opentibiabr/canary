local mType = Game.createMonsterType("Adept of the Cult")
local monster = {}

monster.description = "an adept of the cult"
monster.experience = 400
monster.outfit = {
	lookType = 194,
	lookHead = 95,
	lookBody = 94,
	lookLegs = 94,
	lookFeet = 19,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 254
monster.Bestiary = {
	class = "Human",
	race = BESTY_RACE_HUMAN,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Goroma, Liberty Bay's deeper cult dungeon, Formorgar Mines, Magician Quarter, Forbidden Temple.",
}

monster.health = 430
monster.maxHealth = 430
monster.race = "blood"
monster.corpse = 18030
monster.speed = 95
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
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
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 4,
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

monster.summon = {
	maxSummons = 2,
	summons = {
		{ name = "Ghoul", chance = 10, interval = 2000, count = 2 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Feel the power of the cult!", yell = false },
	{ text = "Praise the voodoo!", yell = false },
	{ text = "Power to the cult!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 65239, maxCount = 60 }, -- Gold Coin
	{ id = 9639, chance = 9636 }, -- Cultish Robe
	{ id = 11492, chance = 9990 }, -- Rope Belt
	{ id = 5810, chance = 1793 }, -- Pirate Voodoo Doll
	{ id = 7426, chance = 531 }, -- Amber Staff
	{ id = 3311, chance = 1158 }, -- Clerical Mace
	{ id = 6089, chance = 440 }, -- Music Sheet (Third Verse)
	{ id = 2828, chance = 871 }, -- Book (Orange)
	{ id = 3054, chance = 1169 }, -- Silver Amulet
	{ id = 3053, chance = 519 }, -- Time Ring
	{ id = 11652, chance = 80 }, -- Broken Key Ring
	{ id = 11455, chance = 90 }, -- Cultish Symbol
	{ id = 3067, chance = 178 }, -- Hailstorm Rod
	{ id = 3030, chance = 323 }, -- Small Ruby
	{ id = 7424, chance = 113 }, -- Lunar Staff
	{ id = 3566, chance = 130 }, -- Red Robe
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -90, condition = { type = CONDITION_POISON, totalDamage = 2, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -70, maxDamage = -150, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "drunk", interval = 2000, chance = 10, range = 7, radius = 1, shootEffect = CONST_ANI_HOLY, effect = CONST_ME_HOLYDAMAGE, target = true, duration = 4000 },
}

monster.defenses = {
	defense = 20,
	armor = 33,
	mitigation = 1.13,
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_HEALING, minDamage = 45, maxDamage = 60, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "invisible", interval = 2000, chance = 10, effect = CONST_ME_YELLOW_RINGS },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
