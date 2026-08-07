local mType = Game.createMonsterType("Werehyaena Shaman")
local monster = {}

monster.description = "a werehyaena shaman"
monster.experience = 2200
monster.outfit = {
	lookType = 1300,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 94,
	lookFeet = 95,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1964
monster.Bestiary = {
	class = "Lycanthrope",
	race = BESTY_RACE_LYCANTHROPE,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "This monster you can find in Hyaena Lairs.",
}

monster.health = 2500
monster.maxHealth = monster.health
monster.race = "blood"
monster.corpse = 34189
monster.speed = 110
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 0,
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
	runHealth = 30,
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

monster.voices = {
	interval = 0,
	chance = 0,
}

monster.loot = {
	{ id = 3035, chance = 100000, maxCount = 3 }, -- Platinum Coin
	{ id = 238, chance = 20000 }, -- Great Mana Potion
	{ id = 33943, chance = 14400 }, -- Werehyaena Nose
	{ id = 3033, chance = 10600, maxCount = 2 }, -- Small Amethyst
	{ id = 16122, chance = 10200 }, -- Green Crystal Splinter
	{ id = 3067, chance = 7100 }, -- Hailstorm Rod
	{ id = 8092, chance = 5300 }, -- Wand of Starstorm
	{ id = 3379, chance = 5000 }, -- Doublet
	{ id = 677, chance = 4600, maxCount = 5 }, -- Small Enchanted Emerald
	{ id = 3091, chance = 4500 }, -- Sword Ring
	{ id = 8094, chance = 4200 }, -- Wand of Voodoo
	{ id = 16123, chance = 4100 }, -- Brown Crystal Splinter
	{ id = 3084, chance = 3500 }, -- Protection Amulet
	{ id = 3429, chance = 2500 }, -- Black Shield
	{ id = 33944, chance = 520 }, -- Werehyaena Talisman
	{ id = 22083, chance = 340 }, -- Moonlight Crystals
	{ id = 34219, chance = 120 }, -- Werehyaena Trophy
}

monster.attacks = {
	{ name = "melee", type = COMBAT_PHYSICALDAMAGE, interval = 2 * 1000, minDamage = 0, maxDamage = -260 },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2 * 1000, chance = 10, minDamage = -280, maxDamage = -325, radius = 3, effect = CONST_ME_HITBYPOISON },
	{ name = "combat", type = COMBAT_EARTHDAMAGE, interval = 2 * 1000, chance = 17, minDamage = -280, maxDamage = -315, range = 5, radius = 4, target = true, shootEffect = CONST_ANI_EARTH, effect = CONST_ME_GREEN_RINGS },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2 * 1000, chance = 15, minDamage = -370, maxDamage = -430, range = 5, radius = 1, target = true, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_MORTAREA },
	{ name = "combat", type = COMBAT_DEATHDAMAGE, interval = 2 * 1000, chance = 13, minDamage = -280, maxDamage = -325, length = 3, spread = 0, effect = CONST_ME_MORTAREA },
}

monster.defenses = {
	{ name = "speed", interval = 2 * 1000, chance = 15, speed = 200, duration = 5 * 1000, effect = CONST_ME_MAGIC_BLUE },
	defense = 0,
	armor = 38,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 25 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 5 },
	{ type = COMBAT_DEATHDAMAGE, percent = -5 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = true },
}

mType:register(monster)
