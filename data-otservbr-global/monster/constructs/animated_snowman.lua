local mType = Game.createMonsterType("Animated Snowman")
local monster = {}

monster.description = "an animated snowman"
monster.experience = 400
monster.outfit = {
	lookType = 1159,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1751
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Percht Island.",
}

monster.health = 450
monster.maxHealth = 450
monster.race = "venom"
monster.corpse = 30335
monster.speed = 115
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 50 }, -- gold coin
	{ id = 30337, chance = 80000 }, -- twig arms
	{ id = 762, chance = 23000, maxCount = 5 }, -- shiver arrow
	{ id = 2992, chance = 5000, maxCount = 5 }, -- snowball
	{ id = 3284, chance = 5000 }, -- ice rapier
	{ id = 829, chance = 5000 }, -- glacier mask
	{ id = 3067, chance = 5000 }, -- hailstorm rod
	{ id = 815, chance = 5000 }, -- glacier amulet
	{ id = 3070, chance = 5000 }, -- moonlight rod
	{ id = 823, chance = 1000 }, -- glacier kilt
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -20 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_ENERGYDAMAGE, minDamage = -10, maxDamage = -40, range = 7, radius = 2, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	mitigation = 0.78,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = -20 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
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
