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
	{ id = 3035, chance = 80000 }, -- platinum coin
	{ id = 238, chance = 23000 }, -- great mana potion
	{ id = 3033, chance = 23000 }, -- small amethyst
	{ id = 3067, chance = 23000 }, -- hailstorm rod
	{ id = 8092, chance = 23000 }, -- wand of starstorm
	{ id = 16122, chance = 23000 }, -- green crystal splinter
	{ id = 22083, chance = 23000 }, -- moonlight crystals
	{ id = 33943, chance = 23000 }, -- werehyaena nose
	{ id = 677, chance = 5000 }, -- small enchanted emerald
	{ id = 3084, chance = 5000 }, -- protection amulet
	{ id = 3091, chance = 5000 }, -- sword ring
	{ id = 3379, chance = 5000 }, -- doublet
	{ id = 3429, chance = 5000 }, -- black shield
	{ id = 8094, chance = 5000 }, -- wand of voodoo
	{ id = 16123, chance = 5000 }, -- brown crystal splinter
	{ id = 33944, chance = 1000 }, -- werehyaena talisman
	{ id = 34219, chance = 260 }, -- werehyaena trophy
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
