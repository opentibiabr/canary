local mType = Game.createMonsterType("Goblin Scavenger")
local monster = {}

monster.description = "a goblin scavenger"
monster.experience = 37
monster.outfit = {
	lookType = 297,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 464
monster.Bestiary = {
	class = "Humanoid",
	race = BESTY_RACE_HUMANOID,
	toKill = 500,
	FirstUnlock = 25,
	SecondUnlock = 250,
	CharmsPoints = 15,
	Stars = 2,
	Occurrence = 0,
	Locations = "Femor Hills, Edron Goblin Cave, and Fenrock.",
}

monster.health = 60
monster.maxHealth = 60
monster.race = "blood"
monster.corpse = 6002
monster.speed = 66
monster.manaCost = 310

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 100,
}

monster.flags = {
	summonable = false,
	attackable = true,
	hostile = true,
	convinceable = true,
	pushable = true,
	rewardBoss = false,
	illusionable = true,
	canPushItems = false,
	canPushCreatures = false,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 10,
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
	{ text = "Shiny, shiny!", yell = false },
	{ text = "You mean!", yell = false },
	{ text = "All mine!", yell = false },
	{ text = "Uhh!", yell = false },
	{ text = "Gimme gimme!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 49950, maxCount = 9 }, -- Gold Coin
	{ id = 1781, chance = 38878, maxCount = 2 }, -- Small Stone
	{ id = 3115, chance = 12402 }, -- Bone
	{ id = 3267, chance = 17692 }, -- Dagger
	{ id = 3578, chance = 13815 }, -- Fish
	{ id = 3361, chance = 7519 }, -- Leather Armor
	{ id = 3355, chance = 11369 }, -- Leather Helmet
	{ id = 3120, chance = 6920 }, -- Mouldy Cheese
	{ id = 3294, chance = 10352 }, -- Short Sword
	{ id = 3462, chance = 9953 }, -- Small Axe
	{ id = 3337, chance = 6087 }, -- Bone Club
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -15 },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -30, range = 7, shootEffect = CONST_ANI_SPEAR, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_LIFEDRAIN, minDamage = -22, maxDamage = -30, range = 7, effect = CONST_ME_MAGIC_RED, target = false },
	{ name = "combat", interval = 2000, chance = 5, type = COMBAT_DEATHDAMAGE, minDamage = -1, maxDamage = -30, range = 7, shootEffect = CONST_ANI_SUDDENDEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
}

monster.defenses = {
	defense = 15,
	armor = 7,
	mitigation = 0.23,
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_HEALING, minDamage = 10, maxDamage = 16, effect = CONST_ME_ENERGYHIT, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 20 },
	{ type = COMBAT_EARTHDAMAGE, percent = -10 },
	{ type = COMBAT_FIREDAMAGE, percent = 0 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 0 },
	{ type = COMBAT_HOLYDAMAGE, percent = 20 },
	{ type = COMBAT_DEATHDAMAGE, percent = -10 },
}

monster.immunities = {
	{ type = "paralyze", condition = false },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = false },
	{ type = "bleed", condition = false },
}

mType:register(monster)
