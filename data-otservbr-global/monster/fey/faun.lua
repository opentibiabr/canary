local mType = Game.createMonsterType("Faun")
local monster = {}

monster.description = "a faun"
monster.experience = 800
monster.outfit = {
	lookType = 980,
	lookHead = 61,
	lookBody = 96,
	lookLegs = 95,
	lookFeet = 62,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1434
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Feyrist (daytime).",
}

monster.health = 900
monster.maxHealth = 900
monster.race = "blood"
monster.corpse = 25815
monster.speed = 105
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
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
	rewardBoss = false,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 20,
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
	{ text = "In vino veritas! Hahaha!", yell = false },
	{ text = "Wine, women and song!", yell = false },
	{ text = "Are you posing a threat to this realm? I suppose so.", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 191 }, -- Gold Coin
	{ id = 25695, chance = 15240 }, -- Dandelion Seeds
	{ id = 236, chance = 12070, maxCount = 2 }, -- Strong Health Potion
	{ id = 3674, chance = 7760 }, -- Goat Grass
	{ id = 25693, chance = 9970 }, -- Shimmering Beetles
	{ id = 25692, chance = 9440, maxCount = 3 }, -- Fresh Fruit
	{ id = 25735, chance = 8020, maxCount = 7 }, -- Leaf Star
	{ id = 3598, chance = 6110, maxCount = 5 }, -- Cookie
	{ id = 2953, chance = 5500 }, -- Panpipes
	{ id = 25737, chance = 5450, maxCount = 3 }, -- Rainbow Quartz
	{ id = 3592, chance = 4910, maxCount = 2 }, -- Grapes
	{ id = 1781, chance = 5219, maxCount = 5 }, -- Small Stone
	{ id = 675, chance = 2360, maxCount = 2 }, -- Small Enchanted Sapphire
	{ id = 239, chance = 3340, maxCount = 2 }, -- Great Health Potion
	{ id = 3575, chance = 2230 }, -- Wood Cape
	{ id = 9014, chance = 520 }, -- Leaf Legs
	{ id = 25699, chance = 450 }, -- Wooden Spellbook
	{ id = 5792, chance = 110 }, -- Die
	{ id = 5014, chance = 30 }, -- Mandrake
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -370 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -115, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "drunk", interval = 2000, chance = 11, length = 4, spread = 2, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 25000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, shootEffect = CONST_ANI_LEAFSTAR, target = false },
}

monster.defenses = {
	defense = 45,
	armor = 45,
	mitigation = 1.10,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 75, maxDamage = 90, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -15 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
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
