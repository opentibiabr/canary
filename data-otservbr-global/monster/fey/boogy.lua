local mType = Game.createMonsterType("Boogy")
local monster = {}

monster.description = "a boogy"
monster.experience = 950
monster.outfit = {
	lookType = 981,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1439
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Feyrist (night time) and its underground (all day).",
}

monster.health = 1300
monster.maxHealth = 1300
monster.race = "blood"
monster.corpse = 25819
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
	{ text = "Go to sleep!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 193 }, -- Gold Coin
	{ id = 25693, chance = 17563 }, -- Shimmering Beetles
	{ id = 236, chance = 14901 }, -- Strong Health Potion
	{ id = 25694, chance = 15181 }, -- Fairy Wings
	{ id = 25735, chance = 8167, maxCount = 7 }, -- Leaf Star
	{ id = 3727, chance = 4530 }, -- Wood Mushroom
	{ id = 24962, chance = 3202, maxCount = 2 }, -- Prismatic Quartz
	{ id = 16126, chance = 3498, maxCount = 2 }, -- Red Crystal Fragment
	{ id = 3738, chance = 3151 }, -- Sling Herb
	{ id = 677, chance = 2418, maxCount = 3 }, -- Small Enchanted Emerald
	{ id = 24390, chance = 2923, maxCount = 3 }, -- Ancient Coin
	{ id = 814, chance = 3007 }, -- Terra Amulet
	{ id = 7439, chance = 1185 }, -- Berserk Potion
	{ id = 3306, chance = 813 }, -- Golden Sickle
	{ id = 25699, chance = 513 }, -- Wooden Spellbook
	{ id = 5014, chance = 86 }, -- Mandrake
	{ id = 9067, chance = 140 }, -- Crystal of Power
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -450 },
	-- bleed
	{ name = "condition", type = CONDITION_BLEEDING, interval = 3000, chance = 11, minDamage = -100, maxDamage = -300, radius = 6, shootEffect = CONST_ANI_WHIRLWINDCLUB, effect = CONST_ME_DRAWBLOOD, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -60, maxDamage = -115, range = 7, shootEffect = CONST_ANI_LARGEROCK, effect = CONST_ME_EXPLOSIONAREA, target = true },
}

monster.defenses = {
	defense = 35,
	armor = 35,
	mitigation = 1.24,
	{ name = "speed", interval = 2000, chance = 15, speedChange = 450, effect = CONST_ME_MAGIC_RED, target = false, duration = 5000 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_HEALING, minDamage = 0, maxDamage = 110, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 70 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 10 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 20 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
