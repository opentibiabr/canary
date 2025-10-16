local mType = Game.createMonsterType("Arctic Faun")
local monster = {}

monster.description = "an arctic faun"
monster.experience = 300
monster.outfit = {
	lookType = 980,
	lookHead = 85,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 85,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1626
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 1,
	Locations = "Arctic Faun's Island.",
}

monster.health = 300
monster.maxHealth = 300
monster.race = "blood"
monster.corpse = 28811
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 5000,
	chance = 8,
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
	canPushItems = false,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = false,
	isPreyExclusive = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Dance with me!", yell = false },
	{ text = "In vino veritas! Hahaha!", yell = false },
	{ text = "Wine, women and song!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 80000, maxCount = 105 }, -- gold coin
	{ id = 236, chance = 23000 }, -- strong health potion
	{ id = 3598, chance = 23000, maxCount = 5 }, -- cookie
	{ id = 3674, chance = 23000 }, -- goat grass
	{ id = 25692, chance = 23000, maxCount = 2 }, -- fresh fruit
	{ id = 25693, chance = 23000 }, -- shimmering beetles
	{ id = 25695, chance = 23000 }, -- dandelion seeds
	{ id = 25735, chance = 23000, maxCount = 3 }, -- leaf star
	{ id = 239, chance = 5000 }, -- great health potion
	{ id = 1781, chance = 5000, maxCount = 2 }, -- small stone
	{ id = 2953, chance = 5000 }, -- panpipes
	{ id = 3592, chance = 5000 }, -- grapes
	{ id = 25737, chance = 5000, maxCount = 2 }, -- rainbow quartz
	{ id = 3575, chance = 1000 }, -- wood cape
	{ id = 9014, chance = 260 }, -- leaf legs
	{ id = 25699, chance = 260 }, -- wooden spellbook
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 1000, chance = 15, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -180, range = 7, shootEffect = CONST_ANI_SNOWBALL, effect = CONST_ME_POFF, target = false },
	{ name = "combat", interval = 1000, chance = 12, type = COMBAT_ENERGYDAMAGE, minDamage = 0, maxDamage = -175, length = 3, spread = 0, effect = CONST_ME_POFF, target = false },
}

monster.defenses = {
	defense = 30,
	armor = 30,
	mitigation = 0.83,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 80 },
	{ type = COMBAT_HOLYDAMAGE, percent = 30 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
