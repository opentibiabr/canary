local mType = Game.createMonsterType("Renegade Quara Pincher")
local monster = {}

monster.description = "a renegade quara pincher"
monster.experience = 2200
monster.outfit = {
	lookType = 77,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1100
monster.Bestiary = {
	class = "Aquatic",
	race = BESTY_RACE_AQUATIC,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 2,
	Locations = "Seacrest Grounds when Seacrest Serpents are not spawning.",
}

monster.health = 2800
monster.maxHealth = 2800
monster.race = "blood"
monster.corpse = 6063
monster.speed = 198
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
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
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 2,
	color = 35,
}

monster.voices = {
	interval = 5000,
	chance = 10,
}

monster.loot = {
	{ name = "platinum coin", chance = 80000, maxCount = 5 },
	{ name = "quara pincers", chance = 18800, maxCount = 1 },
	{ name = "great mana potion", chance = 9720, maxCount = 2 },
	{ name = "great health potion", chance = 9010, maxCount = 2 },
	{ name = "small ruby", chance = 9010, maxCount = 2 },
	{ name = "small diamond", chance = 7060, maxCount = 2 },
	{ name = "mind stone", chance = 6140 },
	{ id = 3039, chance = 5120 }, -- red gem
	{ name = "shrimp", chance = 4810, maxCount = 5 },
	{ name = "vortex bolt", chance = 3790, maxCount = 5 },
	{ id = 281, chance = 1430 }, -- giant shimmering pearl (green)
	{ name = "warrior helmet", chance = 1430 },
	{ name = "fish fin", chance = 920 },
	{ name = "crown armor", chance = 611 },
	{ id = 3053, chance = 410 }, -- time ring
	{ name = "talon", chance = 310 },
	{ name = "glacier robe", chance = 200 },
	{ name = "giant shrimp", chance = 100 },
	{ name = "twiceslicer", chance = 100 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 90, attack = 60, effect = CONST_ME_DRAWBLOOD },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -300, range = 1, effect = CONST_ME_MAGIC_RED, target = false, duration = 3000 },
}

monster.defenses = {
	defense = 50,
	armor = 85,
	mitigation = 1.26,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -25 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 100 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
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
