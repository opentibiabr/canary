local mType = Game.createMonsterType("Weakened Shlorg")
local monster = {}

monster.description = "Weakened Shlorg"
monster.experience = 6500
monster.outfit = {
	lookType = 565,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 10000
monster.maxHealth = 10000
monster.race = "venom"
monster.corpse = 18982
monster.speed = 135
monster.manaCost = 0

monster.changeTarget = {
	interval = 60000,
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
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

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Tchhh!", yell = false },
	{ text = "Slurp!", yell = false },
}

monster.loot = {
	{ id = 19083, chance = 3000 }, -- silver raid token
	{ id = 3031, chance = 100000, maxCount = 105 }, -- gold coin
	{ id = 3035, chance = 100000, maxCount = 8 }, -- platinum coin
	{ id = 19371, chance = 3000 }, -- glass of goo
	{ id = 19372, chance = 3000 }, -- goo shell
	{ id = 3037, chance = 10000 }, -- yellow gem
	{ id = 3038, chance = 10000 }, -- green gem
	{ id = 7643, chance = 10000, maxCount = 3 }, -- ultimate health potion
	{ id = 7642, chance = 10000, maxCount = 3 }, -- great spirit potion
	{ id = 238, chance = 10000, maxCount = 3 }, -- great mana potion
	{ id = 3032, chance = 10000, maxCount = 5 }, -- small emerald
	{ id = 9057, chance = 10000, maxCount = 5 }, -- small topaz
	{ id = 8044, chance = 20000 }, -- belted cape
	{ id = 5910, chance = 10000 }, -- green piece of cloth
	{ id = 5911, chance = 10000 }, -- red piece of cloth
	{ id = 5914, chance = 10000 }, -- yellow piece of cloth
	{ id = 3297, chance = 20000 }, -- serpent sword
	{ id = 8084, chance = 20000 }, -- springsprout rod
	{ id = 8063, chance = 10000 }, -- paladin armor
	{ id = 9667, chance = 100000 }, -- boggy dreads
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 150, attack = 50, condition = { type = CONDITION_POISON, totalDamage = 180, interval = 4000 } },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_LIFEDRAIN, minDamage = -90, maxDamage = -180, length = 4, spread = 0, effect = CONST_ME_MAGIC_GREEN, target = false },
	{ name = "combat", interval = 2000, chance = 14, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -150, radius = 5, effect = CONST_ME_GREEN_RINGS, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 13, minDamage = -360, maxDamage = -440, radius = 5, effect = CONST_ME_GREEN_RINGS, target = false },
	{ name = "shlorg paralyze", interval = 2000, chance = 11, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 10,
	{ name = "combat", interval = 2000, chance = 35, type = COMBAT_HEALING, minDamage = 95, maxDamage = 150, effect = CONST_ME_MAGIC_RED, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 5 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 40 },
	{ type = COMBAT_FIREDAMAGE, percent = 80 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = -10 },
	{ type = COMBAT_HOLYDAMAGE, percent = -5 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
