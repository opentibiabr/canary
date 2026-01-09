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
	{ id = 3031, chance = 100000, maxCount = 105 }, -- Gold Coin
	{ id = 236, chance = 11220 }, -- Strong Health Potion
	{ id = 3598, chance = 5980, maxCount = 5 }, -- Cookie
	{ id = 3674, chance = 8150 }, -- Goat Grass
	{ id = 25692, chance = 10020, maxCount = 2 }, -- Fresh Fruit
	{ id = 25693, chance = 9730 }, -- Shimmering Beetles
	{ id = 25695, chance = 15050 }, -- Dandelion Seeds
	{ id = 25735, chance = 8340, maxCount = 3 }, -- Leaf Star
	{ id = 239, chance = 3640 }, -- Great Health Potion
	{ id = 1781, chance = 5050, maxCount = 2 }, -- Small Stone
	{ id = 2953, chance = 4990 }, -- Panpipes
	{ id = 3592, chance = 5180 }, -- Grapes
	{ id = 25737, chance = 4930, maxCount = 2 }, -- Rainbow Quartz
	{ id = 3575, chance = 1030 }, -- Wood Cape
	{ id = 9014, chance = 320 }, -- Leaf Legs
	{ id = 25699, chance = 200 }, -- Wooden Spellbook
	{ id = 5792, chance = 200 }, -- Die
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
