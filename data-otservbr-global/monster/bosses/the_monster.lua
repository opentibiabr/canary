local mType = Game.createMonsterType("The Monster")
local monster = {}

monster.description = "The Monster"
monster.experience = 30000
monster.outfit = {
	lookType = 1600,
}

monster.bosstiary = {
	bossRaceId = 2299,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 450000
monster.maxHealth = 450000
monster.race = "blood"
monster.corpse = 42247
monster.speed = 180
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 15,
}

monster.strategiesTarget = {
	nearest = 60,
	health = 30,
	damage = 10,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = false,
	pushable = false,
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	critChance = 10,
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

monster.loot = {
	{ name = "platinum coin", chance = 100000, maxcount = 30 },
	{ id = 3039, chance = 35542, maxCount = 2 }, -- red gem
	{ name = "ultimate health potion", chance = 27000, maxcount = 7 },
	{ name = "ultimate mana potion", chance = 24300, maxcount = 5 },
	{ name = "ultimate spirit potion", chance = 25750, maxcount = 4 },
	{ name = "mastermind potion", chance = 23200, maxcount = 3 },
	{ name = "berserk potion", chance = 24800, maxcount = 3 },
	{ name = "bullseye potion", chance = 23500, maxcount = 3 },
	{ name = "yellow gem", chance = 26200, maxcount = 5 },
	{ name = "blue gem", chance = 25100 },
	{ name = "green gem", chance = 24600 },
	{ name = "violet gem", chance = 25350 },
	{ name = "giant amethyst", chance = 4300 },
	{ name = "giant topaz", chance = 4600 },
	{ name = "giant emerald", chance = 4500 },
	{ id = 33778, chance = 900 }, -- raw watermelon turmaline
	{ name = "alchemist's notepad", chance = 420 },
	{ name = "antler-horn helmet", chance = 390 },
	{ name = "mutant bone kilt", chance = 450 },
	{ name = "mutated skin armor", chance = 430 },
	{ name = "mutated skin legs", chance = 410 },
	{ name = "stitched mutant hide legs", chance = 440 },
	{ name = "alchemist's boots", chance = 460 },
	{ name = "mutant bone boots", chance = 400 },
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -2800 },
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_ENERGYDAMAGE, minDamage = -600, maxDamage = -1200, effect = CONST_ME_ENERGYAREA, target = true, radius = 5, range = 3 },
	{ name = "destroy magic walls", interval = 1000, chance = 50 },
}

monster.defenses = {
	defense = 54,
	armor = 59,
	mitigation = 3.7,
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_HEALING, minDamage = 900, maxDamage = 2400, effect = CONST_ME_MAGIC_BLUE, target = false },
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
