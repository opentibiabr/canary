local mType = Game.createMonsterType("Bibby Bloodbath")
local monster = {}

monster.description = "Bibby Bloodbath"
monster.experience = 1500
monster.outfit = {
	lookType = 2,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.bosstiary = {
	bossRaceId = 900,
	bossRace = RARITY_ARCHFOE,
}

monster.health = 1200
monster.maxHealth = 1200
monster.race = "blood"
monster.corpse = 6008
monster.speed = 120
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
	rewardBoss = true,
	illusionable = false,
	canPushItems = true,
	canPushCreatures = true,
	staticAttackChance = 90,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = true,
	canWalkOnPoison = false,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "Don't run, you'll just lose precious fat.", yell = false },
	{ text = "Hex hex!", yell = false },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 100 }, -- Gold Coin
	{ id = 3035, chance = 98933, maxCount = 10 }, -- Platinum Coin
	{ id = 3578, chance = 13509 }, -- Fish
	{ id = 3577, chance = 9194, maxCount = 2 }, -- Meat
	{ id = 3287, chance = 20074, maxCount = 18 }, -- Throwing Star
	{ id = 266, chance = 13134, maxCount = 3 }, -- Health Potion
	{ id = 268, chance = 15947, maxCount = 3 }, -- Mana Potion
	{ id = 3383, chance = 13321 }, -- Dark Armor
	{ id = 3316, chance = 27016 }, -- Orcish Axe
	{ id = 3557, chance = 7130 }, -- Plate Legs
	{ id = 3265, chance = 22700 }, -- Two Handed Sword
	{ id = 3049, chance = 4877 }, -- Stealth Ring
	{ id = 817, chance = 2815 }, -- Magma Amulet
	{ id = 3391, chance = 1558 }, -- Crusader Helmet
	{ id = 3281, chance = 2130 }, -- Giant Sword
	{ id = 7412, chance = 1040 }, -- Butcher's Axe
	{ id = 7395, chance = 1877 }, -- Orc Trophy
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -200 },
	{ name = "combat", interval = 2000, chance = 20, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -200, length = 5, spread = 3, effect = CONST_ME_BLOCKHIT, target = false },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -300, radius = 3, effect = CONST_ME_BLOCKHIT, target = false, duration = 30000 },
}

monster.defenses = {
	defense = 35,
	armor = 58,
	--	mitigation = ???,
	{ name = "invisible", interval = 2000, chance = 15, effect = CONST_ME_MAGIC_BLUE },
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 0 },
	{ type = COMBAT_ENERGYDAMAGE, percent = 0 },
	{ type = COMBAT_EARTHDAMAGE, percent = -20 },
	{ type = COMBAT_FIREDAMAGE, percent = 100 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 100 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 0 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
