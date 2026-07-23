local mType = Game.createMonsterType("Orewalker")
local monster = {}

monster.description = "an orewalker"
monster.experience = 5900
monster.outfit = {
	lookType = 490,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
	lookMount = 0,
}

monster.raceId = 883
monster.Bestiary = {
	class = "Construct",
	race = BESTY_RACE_CONSTRUCT,
	toKill = 2500,
	FirstUnlock = 100,
	SecondUnlock = 1000,
	CharmsPoints = 50,
	Stars = 4,
	Occurrence = 1,
	Locations = "Warzone 3.",
}

monster.health = 7200
monster.maxHealth = 7200
monster.race = "undead"
monster.corpse = 15911
monster.speed = 190
monster.manaCost = 0

monster.changeTarget = {
	interval = 4000,
	chance = 10,
}

monster.strategiesTarget = {
	nearest = 80,
	random = 20,
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
	canPushCreatures = true,
	staticAttackChance = 80,
	targetDistance = 1,
	runHealth = 0,
	healthHidden = false,
	isBlockable = false,
	canWalkOnEnergy = false,
	canWalkOnFire = false,
	canWalkOnPoison = true,
}

monster.light = {
	level = 0,
	color = 0,
}

monster.voices = {
	interval = 5000,
	chance = 10,
	{ text = "CLONK!", yell = true },
}

monster.loot = {
	{ id = 3031, chance = 100000, maxCount = 198 }, -- Gold Coin
	{ id = 3035, chance = 100000, maxCount = 10 }, -- Platinum Coin
	{ id = 10315, chance = 20000 }, -- Sulphurous Stone
	{ id = 16133, chance = 20000 }, -- Pulverized Ore
	{ id = 5880, chance = 15600 }, -- Iron Ore
	{ id = 9057, chance = 15500, maxCount = 3 }, -- Small Topaz
	{ id = 236, chance = 15500, maxCount = 2 }, -- Strong Health Potion
	{ id = 16135, chance = 15200 }, -- Vein of Ore
	{ id = 237, chance = 15100, maxCount = 2 }, -- Strong Mana Potion
	{ id = 16141, chance = 14800, maxCount = 5 }, -- Prismatic Bolt
	{ id = 268, chance = 14700, maxCount = 4 }, -- Mana Potion
	{ id = 16124, chance = 14700, maxCount = 2 }, -- Blue Crystal Splinter
	{ id = 238, chance = 14500, maxCount = 2 }, -- Great Mana Potion
	{ id = 16125, chance = 13100 }, -- Cyan Crystal Fragment
	{ id = 10310, chance = 11900 }, -- Shiny Stone
	{ id = 7643, chance = 9400, maxCount = 2 }, -- Ultimate Health Potion
	{ id = 16121, chance = 7800 }, -- Green Crystal Shard
	{ id = 3097, chance = 4400 }, -- Dwarven Ring
	{ id = 7454, chance = 2900 }, -- Glorious Axe
	{ id = 7413, chance = 2800 }, -- Titan Axe
	{ id = 5904, chance = 2200 }, -- Magic Sulphur
	{ id = 3371, chance = 1800 }, -- Knight Legs
	{ id = 16096, chance = 1500 }, -- Wand of Defiance
	{ id = 3385, chance = 980 }, -- Crown Helmet
	{ id = 3037, chance = 980 }, -- Yellow Gem
	{ id = 3381, chance = 330 }, -- Crown Armor
	{ id = 8050, chance = 330 }, -- Crystalline Armor
	{ id = 16163, chance = 200 }, -- Crystal Crossbow
}

monster.attacks = {
	{ name = "melee", interval = 2000, chance = 100, minDamage = 0, maxDamage = -300 },
	{ name = "orewalker wave", interval = 2000, chance = 15, minDamage = -296, maxDamage = -700, target = false },
	{ name = "combat", interval = 2000, chance = 10, type = COMBAT_PHYSICALDAMAGE, minDamage = 0, maxDamage = -1500, length = 6, spread = 3, effect = CONST_ME_GROUNDSHAKER, target = false },
	-- poison
	{ name = "condition", type = CONDITION_POISON, interval = 2000, chance = 10, minDamage = -800, maxDamage = -1080, radius = 3, shootEffect = CONST_ANI_SMALLEARTH, effect = CONST_ME_SMALLPLANTS, target = true },
	{ name = "speed", interval = 2000, chance = 15, speedChange = -800, radius = 2, effect = CONST_ME_MAGIC_RED, target = false, duration = 20000 },
}

monster.defenses = {
	defense = 45,
	armor = 79,
	mitigation = 2.31,
}

monster.elements = {
	{ type = COMBAT_PHYSICALDAMAGE, percent = 25 },
	{ type = COMBAT_ENERGYDAMAGE, percent = -5 },
	{ type = COMBAT_EARTHDAMAGE, percent = 100 },
	{ type = COMBAT_FIREDAMAGE, percent = 65 },
	{ type = COMBAT_LIFEDRAIN, percent = 0 },
	{ type = COMBAT_MANADRAIN, percent = 0 },
	{ type = COMBAT_DROWNDAMAGE, percent = 0 },
	{ type = COMBAT_ICEDAMAGE, percent = 5 },
	{ type = COMBAT_HOLYDAMAGE, percent = 0 },
	{ type = COMBAT_DEATHDAMAGE, percent = 25 },
}

monster.immunities = {
	{ type = "paralyze", condition = true },
	{ type = "outfit", condition = false },
	{ type = "invisible", condition = true },
	{ type = "bleed", condition = false },
}

mType:register(monster)
