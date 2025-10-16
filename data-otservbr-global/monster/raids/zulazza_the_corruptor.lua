local mType = Game.createMonsterType("Zulazza the Corruptor")
local monster = {}

monster.description = "Zulazza the Corruptor"
monster.experience = 10000
monster.outfit = {
	lookType = 334,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 628,
	bossRace = RARITY_NEMESIS,
}

monster.health = 46500
monster.maxHealth = 46500
monster.race = "blood"
monster.corpse = 10190
monster.speed = 145
monster.manaCost = 0

monster.changeTarget = {
	interval = 2000,
	chance = 10,
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
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 1500,
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
	{ text = "I'm Zulazza, and you won't forget me that fazzt.", yell = false },
	{ text = "Oh, HE will take revenge on zzizz azzault when you zztep in front of HIZZ fazze!", yell = false },
	{ text = "Zzaion is our last zztand! I will not leave wizzout a fight!", yell = false },
	{ text = "Behind zze Great Gate liezz your doom!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 99 }, -- gold coin
	{ id = 3035, chance = 80000, maxCount = 29 }, -- platinum coin
	{ id = 7366, chance = 80000, maxCount = 46 }, -- viper star
	{ id = 5944, chance = 80000, maxCount = 5 }, -- soul orb
	{ id = 9058, chance = 80000, maxCount = 4 }, -- gold ingot
	{ id = 3010, chance = 80000 }, -- emerald bangle
	{ id = 7643, chance = 80000 }, -- ultimate health potion
	{ id = 239, chance = 80000 }, -- great health potion
	{ id = 238, chance = 80000 }, -- great mana potion
	{ id = 7642, chance = 80000 }, -- great spirit potion
	{ id = 7440, chance = 80000 }, -- mastermind potion
	{ id = 36706, chance = 80000 }, -- red gem
	{ id = 3037, chance = 80000 }, -- yellow gem
	{ id = 3038, chance = 80000 }, -- green gem
	{ id = 3041, chance = 80000 }, -- blue gem
	{ id = 3036, chance = 80000 }, -- violet gem
	{ id = 10406, chance = 80000 }, -- zaoan halberd
	{ id = 3415, chance = 80000 }, -- guardian shield
	{ id = 3428, chance = 80000 }, -- tower shield
	{ id = 8896, chance = 80000 }, -- slightly rusted armor
	{ id = 8063, chance = 80000 }, -- paladin armor
	{ id = 3414, chance = 1000 }, -- mastermind shield
	{ id = 10201, chance = 260 }, -- dragon scale boots
	{ id = 8054, chance = 260 }, -- earthborn titan armor
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 200, attack = 200 },
	{ name = "combat", interval = 2000, chance = 40, type = COMBAT_PHYSICALDAMAGE, minDamage = -500, maxDamage = -800, length = 8, spread = 3, effect = CONST_ME_MORTAREA, target = false },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_EARTHDAMAGE, minDamage = -300, maxDamage = -800, radius = 3, effect = CONST_ME_POISONAREA, target = false },
	{ name = "combat", interval = 2000, chance = 25, type = COMBAT_MANADRAIN, minDamage = -50, maxDamage = -130, range = 7, effect = CONST_ME_MAGIC_GREEN, target = true },
	{ name = "speed", interval = 2000, chance = 20, speedChange = -500, range = 7, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 119,
	armor = 96,
	--	mitigation = ???,
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_HEALING, minDamage = 2000, maxDamage = 3000, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 100 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 20 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = 30 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
