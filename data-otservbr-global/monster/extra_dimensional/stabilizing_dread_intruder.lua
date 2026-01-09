local mType = Game.createMonsterType("Stabilizing Dread Intruder")
local monster = {}

monster.description = "a stabilizing dread intruder"
monster.experience = 1900
monster.outfit = {
	lookType = 882,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1267
monster.Bestiary = {
	class = "Extra Dimensional",
	race = BESTY_RACE_EXTRA_DIMENSIONAL,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Otherworld (Edron)",
}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "venom"
monster.corpse = 23478
monster.speed = 145
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 25,
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
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Whirr!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 98730, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 86350, maxCount = 5 }, -- Platinum Coin
	{ id = 238, chance = 9300 }, -- Great Mana Potion
	{ id = 7642, chance = 9300 }, -- Great Spirit Potion
	{ id = 7643, chance = 9260 }, -- Ultimate Health Potion
	{ id = 16125, chance = 5250 }, -- Cyan Crystal Fragment
	{ id = 23513, chance = 9580 }, -- Strange Proto Matter
	{ id = 23517, chance = 9750 }, -- Solid Rage
	{ id = 23522, chance = 9390 }, -- Glistening Bone
	{ id = 23535, chance = 10460 }, -- Energy Bar
	{ id = 23545, chance = 9860 }, -- Energy Drink
	{ id = 3029, chance = 4910, maxCount = 2 }, -- Small Sapphire
	{ id = 3030, chance = 4280, maxCount = 2 }, -- Small Ruby
	{ id = 3033, chance = 4840, maxCount = 2 }, -- Small Amethyst
	{ id = 16120, chance = 5410 }, -- Violet Crystal Shard
	{ id = 16124, chance = 5100 }, -- Blue Crystal Splinter
	{ id = 3036, chance = 209 }, -- Violet Gem
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_DEATHDAMAGE, minDamage = -200, maxDamage = -300, range = 4, radius = 4, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_MORTAREA, target = true },
	{ name = "dread intruder wave", interval = 2000, chance = 25, minDamage = -350, maxDamage = -450, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 46,
	mitigation = 1.37,
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_HEALING, minDamage = 80, maxDamage = 120, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 80 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 70 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
