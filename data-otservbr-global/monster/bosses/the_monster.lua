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
	{ id = 3035, chance = 80000, maxCount = 30 }, -- platinum coin
	{ id = 7643, chance = 80000, maxCount = 7 }, -- ultimate health potion
	{ id = 23373, chance = 80000, maxCount = 5 }, -- ultimate mana potion
	{ id = 23374, chance = 80000, maxCount = 4 }, -- ultimate spirit potion
	{ id = 7440, chance = 80000, maxCount = 3 }, -- mastermind potion
	{ id = 7439, chance = 80000, maxCount = 3 }, -- berserk potion
	{ id = 7443, chance = 80000, maxCount = 3 }, -- bullseye potion
	{ id = 3037, chance = 80000, maxCount = 5 }, -- yellow gem
	{ id = 36706, chance = 80000, maxCount = 2 }, -- red gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 32622, chance = 5000 }, -- giant amethyst
	{ id = 32623, chance = 5000 }, -- giant topaz
	{ id = 30060, chance = 5000 }, -- giant emerald
	{ id = 33780, chance = 1000 }, -- watermelon tourmaline
	{ id = 40594, chance = 260 }, -- alchemists notepad
	{ id = 40588, chance = 260 }, -- antlerhorn helmet
	{ id = 40595, chance = 260 }, -- mutant bone kilt
	{ id = 40591, chance = 260 }, -- mutated skin armor
	{ id = 40590, chance = 260 }, -- mutated skin legs
	{ id = 40589, chance = 260 }, -- stitched mutant hide legs
	{ id = 40592, chance = 260 }, -- alchemists boots
	{ id = 40593, chance = 260 }, -- mutant bone boots
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
