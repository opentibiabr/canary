local mType = Game.createMonsterType("Nymph")
local monster = {}

monster.description = "a nymph"
monster.experience = 850
monster.outfit = {
	lookType = 989,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 1485
monster.Bestiary = {
	class = "Fey",
	race = BESTY_RACE_FEY,
	toKill = 1000,
	FirstUnlock = 50,
	SecondUnlock = 500,
	CharmsPoints = 25,
	Stars = 3,
	Occurrence = 0,
	Locations = "Feyrist",
}

monster.health = 900
monster.maxHealth = 900
monster.race = "blood"
monster.corpse = 25807
monster.speed = 114
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
	{ text = "Looking at a nymph can blind you. Be careful, mortal being!", yell = false },
	{ text = "Are you one of those evil nightmare creatures? Leave this realm alone!", yell = false },
	{ text = "Come here, sweetheart! I won't hurt you! *giggle*", yell = false },
	{ text = "I'm just protecting nature's beauty!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 64849, maxCount = 110 }, -- Gold Coin
	{ id = 25691, chance = 21770 }, -- Wild Flowers
	{ id = 25692, chance = 15070, maxCount = 2 }, -- Fresh Fruit
	{ id = 25696, chance = 12170 }, -- Colourful Snail Shell
	{ id = 25695, chance = 12130 }, -- Dandelion Seeds
	{ id = 238, chance = 3430 }, -- Great Mana Potion
	{ id = 9057, chance = 2390, maxCount = 2 }, -- Small Topaz
	{ id = 678, chance = 1960, maxCount = 2 }, -- Small Enchanted Amethyst
	{ id = 3010, chance = 1780 }, -- Emerald Bangle
	{ id = 9302, chance = 1090 }, -- Sacred Tree Amulet
	{ id = 25698, chance = 760 }, -- Butterfly Ring
	{ id = 237, chance = 890 }, -- Strong Mana Potion
	{ id = 25700, chance = 670 }, -- Dream Blossom Staff
	{ id = 9013, chance = 530 }, -- Flower Wreath
	{ id = 8045, chance = 590 }, -- Hibiscus Dress
	{ id = 3659, chance = 580 }, -- Blue Rose
	{ id = 3079, chance = 369 }, -- Boots of Haste
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -205 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -85, maxDamage = -135, range = 7, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_ENERGYHIT, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_ENERGYDAMAGE, minDamage = -85, maxDamage = -135, range = 4, shootEffect = CONST_ANI_ENERGY, effect = CONST_ME_HEARTS, target = true },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_EARTHDAMAGE, minDamage = -85, maxDamage = -135, range = 7, effect = CONST_ME_HEARTS, target = true },
}

monster.defenses = {
	defense = 60,
	armor = 60,
	mitigation = 1.26,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 75, maxDamage = 90, effect = CONST_ME_MAGIC_BLUE, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = 60 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 40 },
	{ type = COMBAT_DEATHDAMAGE, percent = 40 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
