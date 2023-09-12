local mType = Game.createMonsterType("Vibrant Phantom")
local monster = {}

monster.description = "a vibrant phantom"
monster.experience = 19700
monster.outfit = {
	lookType = 1298,
	lookHead = 85,
	lookBody = 85,
	lookLegs = 88,
	lookFeet = 91,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1929
monster.Bestiary = {
	class = "Undead",
	race = BESTY_RACE_UNDEAD,
	toKill = 5000,
	FirstUnlock = 200,
	SecondUnlock = 2000,
	CharmsPoints = 100,
	Stars = 5,
	Occurrence = 0,
	Locations = "Furious Crater.",
}

monster.health = 27000
monster.maxHealth = 27000
monster.race = "undead"
monster.corpse = 33813
monster.speed = 230
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 0,
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
	{ text = "All this beautiful lightning.", yell = false },
	{ text = "Feel the vibration!", yell = false },
}

monster.loot = {
	{ name = "crystal coin", chance = 66670 },
	{ name = "ultimate health potion", chance = 27960, maxCount = 5 },
	{ name = "terra rod", chance = 13980 },
	{ name = "violet gem", chance = 8600 },
	{ name = "vibrant heart", chance = 6450 },
	{ id = 281, chance = 6450 }, -- giant shimmering pearl
	{ name = "gold ingot", chance = 4300 },
	{ name = "blue crystal shard", chance = 4300 },
	{ name = "vibrant robe", chance = 3230 },
	{ name = "springsprout rod", chance = 3230 },
	{ name = "blue gem", chance = 3230 },
	{ name = "hailstorm rod", chance = 3230 },
	{ name = "underworld rod", chance = 2150 },
	{ name = "violet crystal shard", chance = 1080 },
	{ id = 23529, chance = 1080 }, -- ring of blue plasma
	{ name = "green gem", chance = 1080 },
	{ id = 34109, chance = 20 }, -- bag you desire
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -800 },
	{ name = "extended energy chain", interval = 2000, chance = 15, minDamage = -500, maxDamage = -600, range = 7 },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -800, maxDamage = -1200, range = 7, radius = 4, effect = CONST_ME_ENERGYAREA, target = false },
	{ name = "combat", interval = 3000, chance = 20, type = COMBAT_ENERGYDAMAGE, minDamage = -1000, maxDamage = -1200, range = 7, radius = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYAREA, target = true },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HOLYDAMAGE, minDamage = -1050, maxDamage = -1300, range = 7, shootEffect = CONST_ANI_SMALLHOLY, effect = CONST_ME_HOLYDAMAGE, target = true },
	{ name = "extended holy chain", interval = 2000, chance = 15, minDamage = -1030, maxDamage = -1250, range = 7 },
}

monster.defenses = {
	defense = 100,
	armor = 100,
	mitigation = 2.45,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 10 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = true },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
