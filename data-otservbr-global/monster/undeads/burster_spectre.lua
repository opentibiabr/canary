local mType = Game.createMonsterType("Burster Spectre")
local monster = {}

monster.description = "a burster spectre"
monster.experience = 6000
monster.outfit = {
	lookType = 1122,
	lookHead = 9,
	lookBody = 10,
	lookLegs = 86,
	lookFeet = 79,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1726
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 0,
	Locations = "Haunted Tomb west of Darashia, Buried Cathedral.",
}

monster.health = 6500
monster.maxHealth = 6500
monster.race = "blood"
monster.corpse = 30163
monster.speed = 200
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
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "We came tooo thiiiiss wooorld to... get youuu!", yell = false },
}

monster.loot = {
	{ id = 3035, chance = 80000, maxCount = 7 }, -- platinum coin
	{ id = 7642, chance = 23000, maxCount = 3 }, -- great spirit potion
	{ id = 3084, chance = 23000 }, -- protection amulet
	{ id = 3061, chance = 23000 }, -- life crystal
	{ id = 8094, chance = 5000 }, -- wand of voodoo
	{ id = 3073, chance = 5000 }, -- wand of cosmic energy
	{ id = 3085, chance = 5000 }, -- dragon necklace
	{ id = 30203, chance = 5000 }, -- blue ectoplasm
	{ id = 815, chance = 5000 }, -- glacier amulet
	{ id = 3060, chance = 5000 }, -- orb
	{ id = 3055, chance = 5000 }, -- platinum amulet
	{ id = 3067, chance = 1000 }, -- hailstorm rod
	{ id = 30180, chance = 1000 }, -- hexagonal ruby
	{ id = 16118, chance = 1000 }, -- glacial rod
	{ id = 3062, chance = 260 }, -- mind stone
	{ id = 3082, chance = 260 }, -- elven amulet
	{ id = 3083, chance = 260 }, -- garlic necklace
	{ id = 9304, chance = 260 }, -- shockwave amulet
	{ id = 3058, chance = 260 }, -- strange symbol
	{ id = 3081, chance = 260 }, -- stone skin amulet
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -400 },
	{ name = "combat", interval = 2700, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -250, maxDamage = -400, radius = 1, range = 5, effect = CONST_ME_ICEAREA, target = true }, --ice box
	{ name = "combat", interval = 3500, chance = 25, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -400, radius = 5, range = 5, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEAREA, target = true }, --ava
	{ name = "combat", interval = 3900, chance = 20, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -400, range = 5, shootEffect = CONST_ANI_ICE, effect = CONST_ME_ICEATTACK, target = true }, -- icicle
	{ name = "combat", interval = 4400, chance = 27, type = COMBAT_ICEDAMAGE, minDamage = -300, maxDamage = -450, length = 4, spread = 2, effect = CONST_ME_ICEATTACK, target = false }, -- wave
	{ name = "combat", interval = 5500, chance = 47, type = COMBAT_LIFEDRAIN, minDamage = -300, maxDamage = -400, radius = 3, effect = CONST_ME_BLUE_ENERGY_SPARK, target = false }, -- life drain bomb
}

monster.defenses = {
	defense = 70,
	armor = 70,
	mitigation = 2.11,
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_HEALING, minDamage = 150, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.reflects = {
	{ type = COMBAT_ICEDAMAGE, percent = 133 },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 70 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
