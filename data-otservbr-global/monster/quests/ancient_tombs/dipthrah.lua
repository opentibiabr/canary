local mType = Game.createMonsterType("Dipthrah")
local monster = {}

monster.description = "Dipthrah"
monster.experience = 2900
monster.outfit = {
	lookType = 87,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 4200
monster.maxHealth = 4200
monster.race = "undead"
monster.corpse = 6031
monster.speed = 240
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
}

monster.bosstiary = {
	bossRaceId = 87,
	bossRace = RARITY_BANE,
}

monster.strategiesTarget = {
	nearest = 70,
	damage = 30,
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
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.summon = {
	maxSummons = 4,
	summons = {
		{ name = "Priestess", chance = 15, interval = 2000, count = 4 },
	},
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "You can't escape death forever", yell = false },
	{ text = "Come closer to learn the final lesson", yell = false },
	{ text = "Undeath will shatter my shackles.", yell = false },
	{ text = "You don't need this magic anymore.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 208 }, -- gold coin
	{ id = 3029, chance = 80000, maxCount = 3 }, -- small sapphire
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 3051, chance = 80000 }, -- energy ring
	{ id = 3062, chance = 1000 }, -- mind stone
	{ id = 3041, chance = 1000 }, -- blue gem
	{ id = 10290, chance = 260 }, -- mini mummy
	{ id = 3077, chance = 260 }, -- ankh
	{ id = 3324, chance = 260 }, -- skull staff
	{ id = 3334, chance = 260 }, -- pharaoh sword
	{ id = 3241, chance = 80000 }, -- ornamented ankh
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200, condition = { type = CONDITION_POISON, totalDamage = 65, interval = 4000 } },
	{ name = "combat", interval = 4000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -100, maxDamage = -800, range = 1, target = false },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_MANADRAIN, minDamage = -100, maxDamage = -500, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "speed", interval = 1000, chance = 15, speedChange = -650, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 50000 },
	{ name = "drunk", interval = 1000, chance = 12, radius = 7, effect = CONST_ME_LOSEENERGY, target = false },
	{ name = "melee", interval = 3000, chance = 34, minDamage = -50, maxDamage = -600 },
}

monster.defenses = {
	defense = 25,
	armor = 25,
	{ name = "combat", interval = 1000, chance = 25, type = COMBAT_HEALING, minDamage = 100, maxDamage = 200, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 100 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 0 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 30 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
