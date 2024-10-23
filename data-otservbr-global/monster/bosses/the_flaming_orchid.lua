local mType = Game.createMonsterType("The Flaming Orchid")
local monster = {}

monster.description = "a flaming orchid"
monster.experience = 8500
monster.outfit = {
	lookType = 150,
	lookHead = 114,
	lookBody = 94,
	lookLegs = 78,
	lookFeet = 79,
	lookAddons = 1,
	lookMount = 0,
}

monster.health = 4000
monster.maxHealth = 4000
monster.race = "blood"
monster.corpse = 21987 -- review later
monster.speed = 210
monster.manaCost = 0

monster.events = {
	"killingLibrary",
}

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
	illusionable = true,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 80,
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
	interval = 2000,
	chance = 7,
	{ text = "I will end your torment. Do not run, little mortal.", yell = true },
	{ text = "*SNIFF* *SNIFF* BLOOD! I CAN SMELL YOU, MORTAL!!", yell = true },
}

monster.loot = {
	{ name = "gold coin", chance = 100000, maxCount = 250 },
	{ name = "platinum coin", chance = 9240, maxCount = 10 },
	{ id = 3039, chance = 18200 }, -- red gem
	{ name = "gold ingot", chance = 29700, maxCount = 5 },
	{ name = "assassin star", chance = 29700, maxCount = 13 },
	{ name = "demonic essence", chance = 330 },
	{ name = "great spirit potion", chance = 330 },
	{ name = "soul orb", chance = 19530 },
	{ name = "small amethyst", chance = 8310, maxCount = 2 },
	{ name = "small amethyst", chance = 8310, maxCount = 2 },
	{ name = "ultimate health potion", chance = 700, maxCount = 4 },
	{ name = "golden lotus brooch", chance = 19740 },
	{ name = "green gem", chance = 15780 },
	{ name = "magma coat", chance = 1050 },
	{ name = "moonlight rod", chance = 1050 },
	{ name = "necrotic rod", chance = 1050 },
	{ name = "oriental shoes", chance = 490 },
	{ name = "peacock feather fan", chance = 16870 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -25 },
	{ name = "combat", interval = 1000, chance = 10, type = COMBAT_DEATHDAMAGE, minDamage = -400, maxDamage = -700, range = 7, effect = CONST_ANI_DEATH, target = true },
	{ name = "Ignite", interval = 2000, chance = 20, range = 7, radius = 1, target = true, shootEffect = CONST_ANI_FIRE },
	{ name = "big death wave", interval = 4000, chance = 18, minDamage = 0, maxDamage = -500 }, -- review later
	{ name = "aggressivelavawave", interval = 5000, chance = 19, minDamage = 0, maxDamage = -200 }, -- review later
	{ name = "combat", interval = 6000, chance = 20, type = COMBAT_FIREDAMAGE, range = 5, radius = 7, target = true, minDamage = -100, maxDamage = -250, shootEffect = CONST_ANI_FIRE, effect = CONST_ME_FIREAREA, target = false },
}

monster.defenses = {
	defense = 55,
	armor = 55,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 50, maxDamage = 280, effect = CONST_ME_MAGIC_BLUE, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = 320, duration = 5000, areaEffect = CONST_ME_MAGIC_RED },
	{ name = "invisible", interval = 1000, chance = 100, duration = 10000, areaEffect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
