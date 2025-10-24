local mType = Game.createMonsterType("Ethershreck")
local monster = {}

monster.description = "Ethershreck"
monster.experience = 5600
monster.outfit = {
	lookType = 351,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.health = 9500
monster.maxHealth = 9500
monster.race = "undead"
monster.corpse = 10445
monster.speed = 160
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 5,
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
	staticAttackChance = 70,
	targetDistance = 1,
	runHealth = 366,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = true,
	canWalkOnFire = true,
	canWalkOnPoison = true,
}

monster.light = {
	level = 4,
	color = 119,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "EMBRACE MY GIFTS!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 99444, maxCount = 230 }, -- Gold Coin
	{ id = 3035, chance = 96667, maxCount = 15 }, -- Platinum Coin
	{ id = 9057, chance = 97777, maxCount = 10 }, -- Small Topaz
	{ id = 6499, chance = 96667 }, -- Demonic Essence
	{ id = 281, chance = 100000 }, -- Giant Shimmering Pearl
	{ id = 10450, chance = 97777 }, -- Undead Heart
	{ id = 7643, chance = 61945 }, -- Ultimate Health Potion
	{ id = 239, chance = 30280, maxCount = 3 }, -- Great Health Potion
	{ id = 7642, chance = 29162, maxCount = 3 }, -- Great Spirit Potion
	{ id = 238, chance = 33608, maxCount = 3 }, -- Great Mana Potion
	{ id = 10449, chance = 99444 }, -- Ghastly Dragon Head
	{ id = 10386, chance = 27773 }, -- Zaoan Shoes
	{ id = 10310, chance = 45834 }, -- Shiny Stone
	{ id = 10388, chance = 11350 }, -- Drakinata
	{ id = 10385, chance = 10275 }, -- Zaoan Helmet
	{ id = 10451, chance = 46670 }, -- Jade Hat
	{ id = 10438, chance = 14718 }, -- Spellweaver's Robe
	{ id = 10406, chance = 70836 }, -- Zaoan Halberd
	{ id = 10389, chance = 1000 }, -- Traditional Sai
	{ id = 10387, chance = 14444 }, -- Zaoan Legs
	{ id = 10384, chance = 14168 }, -- Zaoan Armor
	{ id = 10390, chance = 2150 }, -- Zaoan Sword
	{ id = 50259, chance = 310 }, -- Zaoan Monk Robe
	{ id = 10323, chance = 4443 }, -- Guardian Boots
	{ id = 12801, chance = 1230 }, -- Golden Can of Oil
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, skill = 80, attack = 100 },
	{ name = "combat", interval = 2000, chance = 15, type = COMBAT_LIFEDRAIN, minDamage = -80, maxDamage = -230, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "ghastly dragon curse", interval = 2000, chance = 10, range = 7, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -920, maxDamage = -1260, range = 7, shootEffect = CONST_ANI_DEATH, effect = CONST_ME_SMALLCLOUDS, target = false },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_LIFEDRAIN, minDamage = -90, maxDamage = -350, range = 7, effect = CONST_ME_MAGIC_RED, target = true },
	{ name = "combat", interval = 2000, chance = 13, type = COMBAT_DEATHDAMAGE, minDamage = -70, maxDamage = -180, radius = 4, effect = CONST_ME_MORTAREA, target = false },
}

monster.defenses = {
	defense = 35,
	armor = 45,
	mitigation = 1.74,
	{ name = "combat", interval = 2000, chance = 9, type = COMBAT_HEALING, minDamage = 70, maxDamage = 300, effect = CONST_ME_MAGIC_GREEN, target = false },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = -10 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -10 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 10 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 50 },
	{ type = COMBAT_HOLYDAMAGE, percent = -15 },
	{ type = COMBAT_DEATHDAMAGE, percent = 100 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
