local mType = Game.createMonsterType("Dark Faun")
local monster = {}

monster.description = "a dark faun"
monster.experience = 900
monster.outfit = {
	lookType = 980,
	lookHead = 94,
	lookBody = 95,
	lookLegs = 0,
	lookFeet = 94,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1496
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Feyrist (nighttime) and its underground (all day).",
}

monster.health = 1100
monster.maxHealth = 1100
monster.race = "blood"
monster.corpse = 25814
monster.speed = 108
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
	{ text = "This will be your last dance!", yell = false },
	{ text = "This is a nightmare and you won't wake up!", yell = false },
	{ text = "Blood, fight and rage!", yell = false },
	{ text = "You're a threat to this realm! You have to die!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 149 }, -- Gold Coin
	{ id = 236, chance = 11762, maxCount = 2 }, -- Strong Health Potion
	{ id = 3674, chance = 8312 }, -- Goat Grass
	{ id = 24383, chance = 5783, maxCount = 2 }, -- Cave Turnip
	{ id = 25693, chance = 10299 }, -- Shimmering Beetles
	{ id = 25694, chance = 13814 }, -- Fairy Wings
	{ id = 25735, chance = 6952, maxCount = 8 }, -- Leaf Star
	{ id = 239, chance = 3688, maxCount = 2 }, -- Great Health Potion
	{ id = 675, chance = 2229, maxCount = 2 }, -- Small Enchanted Sapphire
	{ id = 1781, chance = 5064, maxCount = 5 }, -- Small Stone
	{ id = 2953, chance = 2881 }, -- Panpipes
	{ id = 3575, chance = 1820 }, -- Wood Cape
	{ id = 3728, chance = 5290, maxCount = 2 }, -- Dark Mushroom
	{ id = 24962, chance = 5536 }, -- Prismatic Quartz
	{ id = 9014, chance = 671 }, -- Leaf Legs
	{ id = 5014, chance = 41 }, -- Mandrake
	{ id = 5792, chance = 45 }, -- Die
	{ id = 25699, chance = 464 }, -- Wooden Spellbook
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -515 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -60, maxDamage = -115, range = 7, shootEffect = CONST_ANI_POISON, effect = CONST_ME_POISONAREA, target = true },
	{ name = "drunk", interval = 2000, chance = 11, length = 4, spread = 2, effect = CONST_ME_SOUND_PURPLE, target = false, duration = 25000 },
	{ name = "combat", interval = 2000, chance = 30, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -100, range = 7, shootEffect = CONST_ANI_LEAFSTAR, target = false },
}

monster.defenses = {
	defense = 50,
	armor = 50,
	mitigation = 1.21,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 85, maxDamage = 105, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = -5 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = -10 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
